//
//  ShopTypeVC.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 13/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ShopTypeVC: UIViewController {

    lazy private var tableView: UITableView = {
           let tv = UITableView(frame: .zero, style: .plain)
            tv.register(ShopTypeTVCell.self, forCellReuseIdentifier: ShopTypeTVCell.reuseIdentifier)
             tv.estimatedRowHeight = 80
             tv.rowHeight = 80
             tv.translatesAutoresizingMaskIntoConstraints = false
             tv.separatorStyle = .none
             tv.sectionHeaderHeight = 10
             tv.estimatedSectionHeaderHeight = 10
             return tv
         }()
       
       lazy private var buttonFilter: UIButton = {
           [unowned self] in
           let btn = UIButton(frame: .zero)
           btn.setTitle("Apply", for: .normal)
           btn.titleLabel?.font =  .systemFont(ofSize: 17, weight: .heavy)
           btn.setTitleColor(.white, for: .normal)
           btn.backgroundColor = .commonGreen
           btn.translatesAutoresizingMaskIntoConstraints = false
           return btn
       }()
       

       let backButton = UIBarButtonItem(title: "X", style: .plain, target: self, action: #selector(popThisVC))
       lazy private var buttonReset = UIBarButtonItem(title: "Reset", style: .plain, target: self , action: #selector(resetData))
    
        let relayModel = BehaviorRelay<FilterShopTypeCellData>(value: FilterShopTypeCellData(state: .goldMerchant, goldMerchant: 2, isOfficial: true))
        let viewModelPayLoad = BehaviorRelay<FilterShopTypeCellData>(value: FilterShopTypeCellData(state: .goldMerchant, goldMerchant: 2,isOfficial: true))
        let viewModel = ShopTypeVM()
        private let disposeBag = DisposeBag()
    
        override func viewDidLoad() {
            super.viewDidLoad()
            self.view.backgroundColor = .white
            self.setupView()
            self.setupViewModel()
        }
}

extension ShopTypeVC {
    @objc func resetData(){
            self.relayModel.accept(FilterShopTypeCellData(state: .goldMerchant, goldMerchant: SearchConstant.goldMerchant, isOfficial: SearchConstant.offical))
    }
       
   @objc func popThisVC(){
           self.navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        backButton.tintColor = UIColor.white
        title = "Shop Type"
        
        self.navigationController?.navigationBar.tintColor = .commonGreen
        self.navigationItem.rightBarButtonItem = self.buttonReset
        self.navigationItem.backBarButtonItem = self.backButton
            view.addSubview(tableView)
            view.addSubview(buttonFilter)
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
           ])
        tableView.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 242/255, alpha: 1)
    }
    
}


extension ShopTypeVC {
    
    private func setupViewModel(){
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, CellModel>>(configureCell: { dataSource, table, indexPath, item in
          switch item {
          case .goldMerchant(let shopTypeCellData) :
            return self.viewModel.makeCellShopType(table:  self.tableView, element: shopTypeCellData, indexPath: indexPath)
          case .official(let shopTypeCellData) :
            return self.viewModel.makeCellShopType(table:  self.tableView, element: shopTypeCellData, indexPath: indexPath)
          }
        })
        
        let input = ShopTypeVM.Input(
            didSetPayloadTrigger: self.viewModelPayLoad.asDriver(),
            resetPayloadTrigger: self.relayModel.asDriver(),
            applyFilter: self.buttonFilter.rx.controlEvent(.touchUpInside).asDriver()
           )
           
        let output = self.viewModel.transform(input: input)
        
        output.cellData.asObservable().bind(
            onNext : {
            value in
            let cellData = value
                
            let section = Observable.just([
              SectionModel(model: "Gold Merchant", items: [
                CellModel.goldMerchant(FilterShopTypeCellData(state: .goldMerchant, goldMerchant: cellData.goldMerchant, isOfficial: cellData.isOfficial))
              ]),
              SectionModel(model: "Official", items: [
                CellModel.official(FilterShopTypeCellData(state: .official, goldMerchant: cellData.goldMerchant, isOfficial: cellData.isOfficial))
              ])
            ])
            self.tableView.rx.base.dataSource = nil
            section.bind(to: self.tableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
                
            }
        ).disposed(by: disposeBag)
        
        
    }
    
    enum CellModel {
      case goldMerchant(FilterShopTypeCellData)
      case official(FilterShopTypeCellData)
    }
       
}
