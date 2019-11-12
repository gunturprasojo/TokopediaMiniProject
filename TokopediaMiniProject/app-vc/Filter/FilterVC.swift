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
import RxDataSources


class FilterVC: UIViewController {

    //Outlet
     lazy private var tableView: UITableView = {
          let tv = UITableView(frame: .zero, style: .plain)
          tv.register(FilterShopCriteriaCell.self, forCellReuseIdentifier: FilterShopCriteriaCell.reuseIdentifier)
          tv.register(FilterShopTypeCell.self, forCellReuseIdentifier: FilterShopTypeCell.reuseIdentifier)
          tv.estimatedRowHeight = 170
          tv.rowHeight = 170
          tv.translatesAutoresizingMaskIntoConstraints = false
          tv.separatorStyle = .none
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
    
    var criteriaCell = FilterShopCriteriaCell()
    var shopTypeCell = FilterShopTypeCell()

    let callbackPayload = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
    let viewModelPayLoad = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
    let wholeSaleDriver = BehaviorRelay<Bool>(value: false)
    
    var servicePayload = SearchViewModelData()
    
      //Model
    private let viewModel = FilterViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        servicePayload = viewModelPayLoad.value
        self.setupView()
        self.setupViewModel()
    }
}

extension FilterVC {
    @objc func popThisVC(){
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
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { dataSource, table, indexPath, item in
          switch item {
          case .shopCriteria(let shopCriteriaCellData) :
            return self.makeCellShopCriteria(table:  self.tableView, element:  shopCriteriaCellData, indexPath: indexPath)
          case .shopType(let shopTypeCellData) :
            return self.makeCellShopType(table:  self.tableView, element: shopTypeCellData, indexPath: indexPath)
          }
        })
        
        
        let input = FilterViewModel.Input(
            didSetPayloadTrigger: viewModelPayLoad.asDriver()
           )
           
        let output = self.viewModel.transform(input: input)
        
        output.cellData.asObservable().bind(
            onNext : {
            value in
            self.servicePayload = value
            let section = Observable.just([
              SectionModel(model: "Shop Criteria", items: [
                CellModel.shopCriteria(FilterShopCriteriaCellData(maxPrice: value.valMaxPrice, minPrice: value.valMinPrice, isWholeSale: value.wholeSale))
              ]),
              SectionModel(model: "Shop Type", items: [
                CellModel.shopType(FilterShopTypeCellData(goldMerchant: value.fShop, isOfficial: value.official))
              ])
            ])
                
            self.tableView.rx.base.dataSource = nil
            section.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
                
            }
        ).disposed(by: disposeBag)
        
    }
    
    func makeCellShopCriteria(table : UITableView, element : FilterShopCriteriaCellData, indexPath: IndexPath) -> UITableViewCell{
        self.criteriaCell = self.tableView.dequeueReusableCell(withIdentifier: FilterShopCriteriaCell.reuseIdentifier, for: indexPath) as! FilterShopCriteriaCell
        self.criteriaCell.configureCell(with: element)
        self.criteriaCell.selectionStyle = .none
    
        let criteriaCellOutput = self.criteriaCell.cellOutput()
        criteriaCellOutput.wholeSaleControl.asObservable().subscribe(
            onNext: {
                value in
                print("cell action received \(value)")
                var tempData = SearchViewModelData()
                tempData = self.viewModelPayLoad.value
                tempData.wholeSale = value
                self.servicePayload = tempData
            }
        ).disposed(by: disposeBag)
        
        
        return  self.criteriaCell
    }
    
    func makeCellShopType(table : UITableView, element : FilterShopTypeCellData, indexPath: IndexPath) -> UITableViewCell{
        self.shopTypeCell =  self.tableView.dequeueReusableCell(withIdentifier: FilterShopTypeCell.reuseIdentifier, for: indexPath) as! FilterShopTypeCell
        self.shopTypeCell.configureCell(with: element)
        self.shopTypeCell.selectionStyle = .none
        return  self.shopTypeCell
    }
    
    enum CellModel {
      case shopCriteria(FilterShopCriteriaCellData)
      case shopType(FilterShopTypeCellData)
    }
       
}
