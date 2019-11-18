//
//  ShopTypeVM.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 15/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//




import UIKit
import Foundation
import RxSwift
import RxCocoa



class ShopTypeVM: NSObject {
    
    //============ Business Process
    struct Input {
        let didSetPayloadTrigger : Driver<SearchViewModelData>
        let applyFilter : Driver<Void>
    }
    
    struct Output {
         let cellData : Driver<SearchViewModelData>
    }
    //============ Business Process
    
    
    var servicePayload = SearchViewModelData()
    let disposeBag = DisposeBag()
    
    
    let relayModel = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
    
    func transform(input: Input) -> Output {
        let payloadModelTrigger = input.didSetPayloadTrigger.asDriver()
        
       let payLoadProcess = payloadModelTrigger.flatMapLatest{
            value -> Driver<SearchViewModelData> in
            self.relayModel.accept(value)
        return self.relayModel.asDriver()
        }
        
        input.applyFilter.drive(
            onNext: {
                value in
                self.applyFilter()
            }
        ).disposed(by: disposeBag)
        
        return Output(
            cellData: payLoadProcess.asDriver()
        )
    }
    
    
    var criteriaCell = FilterShopCriteriaTVCell()
    var shopTypeCell = FilterShopTypeTVCell()
    func makeCellShopCriteria(table : UITableView, element : FilterShopCriteriaCellData, indexPath: IndexPath) -> UITableViewCell{
        self.criteriaCell = table.dequeueReusableCell(withIdentifier: FilterShopCriteriaTVCell.reuseIdentifier, for: indexPath) as! FilterShopCriteriaTVCell
        self.criteriaCell.configureCell(with: element)
        self.criteriaCell.selectionStyle = .none
    
        let criteriaCellOutput = self.criteriaCell.cellOutput()
        criteriaCellOutput.wholeSaleControl.asObservable().subscribe(
            onNext: {
                value in
                var tempData = SearchViewModelData()
                tempData = self.relayModel.value
                tempData.wholeSale = value
                self.servicePayload = tempData
            }
        ).disposed(by: disposeBag)
        
        criteriaCellOutput.maximumPriceControl.asObservable().subscribe(
            onNext: {
                value in
                var tempData = SearchViewModelData()
                tempData = self.relayModel.value
                tempData.valMaxPrice = value
                self.servicePayload = tempData
        }).disposed(by: disposeBag)
        
        
        return  self.criteriaCell
    }
    
    func makeCellShopType(table : UITableView, element : FilterShopTypeCellData, indexPath: IndexPath) -> UITableViewCell{
        self.shopTypeCell =  table.dequeueReusableCell(withIdentifier: FilterShopTypeTVCell.reuseIdentifier, for: indexPath) as! FilterShopTypeTVCell
        var temp = element
        temp.goldMerchant = 2
        temp.isOfficial = true
        self.shopTypeCell.configureCell(with: temp)
        self.shopTypeCell.selectionStyle = .none
        return  self.shopTypeCell
    }
    
   let callbackPayload = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
}


extension ShopTypeVM {
    func applyFilter(){
        servicePayload.currentPageInquiry = 0
        callbackPayload.accept(servicePayload)
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
      }
}
