//
//  FilterViewModel.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 10/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//


import UIKit
import Foundation
import RxSwift
import RxCocoa



class FilterViewModel: NSObject {
    
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
    
    
    var criteriaCell = FilterShopCriteriaCell()
    var shopTypeCell = FilterShopTypeCell()
    func makeCellShopCriteria(table : UITableView, element : FilterShopCriteriaCellData, indexPath: IndexPath) -> UITableViewCell{
        self.criteriaCell = table.dequeueReusableCell(withIdentifier: FilterShopCriteriaCell.reuseIdentifier, for: indexPath) as! FilterShopCriteriaCell
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
        self.shopTypeCell =  table.dequeueReusableCell(withIdentifier: FilterShopTypeCell.reuseIdentifier, for: indexPath) as! FilterShopTypeCell
        self.shopTypeCell.configureCell(with: element)
        self.shopTypeCell.selectionStyle = .none
        return  self.shopTypeCell
    }
    
   let callbackPayload = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
}


extension FilterViewModel {
    func applyFilter(){
        servicePayload.currentPageInquiry = 0
        callbackPayload.accept(servicePayload)
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
      }
}
