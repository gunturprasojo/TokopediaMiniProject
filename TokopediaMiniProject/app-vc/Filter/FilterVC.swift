//
//  FilterVC.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 10/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class FilterVC: UIViewController {

    //Outlet
     lazy private var tableView: UITableView = {
          let tv = UITableView(frame: .zero, style: .plain)
          tv.register(FilterShopCriteriaCell.self, forCellReuseIdentifier: FilterShopCriteriaCell.reuseIdentifier)
          tv.register(FilterShopTypeCell.self, forCellReuseIdentifier: FilterShopTypeCell.reuseIdentifier)
          tv.estimatedRowHeight = 150
          tv.rowHeight = 150
          tv.translatesAutoresizingMaskIntoConstraints = false
          return tv
      }()
    
    let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(popThisVC))
    
    lazy private var buttonFilter: UIButton = {
        [unowned self] in
        let btn = UIButton(frame: .zero)
        btn.setTitle("Apply", for: .normal)
        btn.titleLabel?.font =  .systemFont(ofSize: 17, weight: .heavy)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .commonGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(popThisVC), for: .touchDown)
        return btn
    }()
    
    lazy private var nextPageIndicator : UIActivityIndicatorView = {
        [unowned self] in
        let act = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        act.color = .commonGreen
        act.translatesAutoresizingMaskIntoConstraints = false
        return act
    }()

    let callbackPayload = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
    let viewModelPayLoad = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
    
    
      //Model
    private let viewModel = FilterViewModel()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupViewModel()
    }
    
}

extension FilterVC {
    @objc func popThisVC(){
        
        var servicePayload = viewModelPayLoad.value
        if servicePayload.valProduct == "apple" {
            servicePayload.valProduct = "samsung"
             servicePayload.valMaxPrice = 100000000
            servicePayload.valMinPrice = 1000000
        }else {
            servicePayload.valProduct = "apple"
            servicePayload.valMaxPrice = 25000
            servicePayload.valMinPrice = 12500
        }
        
        servicePayload.currentPageInquiry = 0
        callbackPayload.accept(servicePayload)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
            backButton.tintColor = UIColor.white
            title = "Filter"
            self.navigationController?.navigationBar.tintColor = .black
        
        
            view.addSubview(tableView)
            view.addSubview(buttonFilter)
            view.addSubview(nextPageIndicator)
        
           NSLayoutConstraint.activate([
               tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
               tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
               tableView.topAnchor.constraint(equalTo: view.topAnchor),
               tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                      constant: -(self.view.frame.height * 0.1)),
               
               buttonFilter.leftAnchor.constraint(equalTo: view.leftAnchor),
               buttonFilter.rightAnchor.constraint(equalTo: view.rightAnchor),
               buttonFilter.topAnchor.constraint(equalTo: tableView.bottomAnchor),
               buttonFilter.bottomAnchor.constraint(equalTo: view.bottomAnchor),
               
               nextPageIndicator.centerXAnchor.constraint(equalTo: buttonFilter.centerXAnchor, constant: -75),
               nextPageIndicator.centerYAnchor.constraint(equalTo: buttonFilter.centerYAnchor, constant: 1),
               nextPageIndicator.heightAnchor.constraint(equalToConstant: 35)
               
               
           ])
        tableView.backgroundColor = .white
    }
    


}

extension FilterVC {
    private func setupViewModel(){
          let input = FilterViewModel.Input(
            didSetPayloadTrigger: viewModelPayLoad.asDriver()
           )
           
          let output = self.viewModel.transform(input: input)
            
       
        output.filterShopCriteriaData.drive(
            tableView.rx.items(cellIdentifier: FilterShopCriteriaCell.reuseIdentifier, cellType: FilterShopCriteriaCell.self)
            )
        {
           row, model, cell in
            cell.configureCell(with: model)
        }.disposed(by: disposeBag)
        
    }
       
}
