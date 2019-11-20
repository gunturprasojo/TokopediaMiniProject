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
        let didSetPayloadTrigger : Driver<FilterShopTypeCellData>
        let resetPayloadTrigger : Driver<FilterShopTypeCellData>
        let applyFilter : Driver<Void>
    }
    
    struct Output {
        let cellData : Driver<FilterShopTypeCellData>
    }
    //============ Business Process
    
    let relayModel = BehaviorRelay<FilterShopTypeCellData>(value: FilterShopTypeCellData(state: .goldMerchant, goldMerchant: 2, isOfficial: true))
    
    let relayGoldMerchant = BehaviorRelay<Bool>(value: true)
    let relayIsOfficial = BehaviorRelay<Bool>(value: true)
    
     let disposeBag = DisposeBag()

    func transform(input: Input) -> Output {
        let payloadModelTrigger = input.didSetPayloadTrigger.asDriver()
        let resetModelTrigger = input.resetPayloadTrigger.asDriver()
        
        var payLoadProcess = payloadModelTrigger.flatMapLatest{
                  value -> Driver<FilterShopTypeCellData> in
                    self.relayModel.accept(value)
                    
                    self.relayIsOfficial.accept(value.isOfficial)
                    return self.relayModel.asDriver()
        }
        
        payLoadProcess = resetModelTrigger.flatMapLatest{
                   val -> Driver<FilterShopTypeCellData> in
                    self.relayGoldMerchant.accept((val.goldMerchant == 2))
                    self.relayIsOfficial.accept(val.isOfficial)
                    self.relayModel.accept(FilterShopTypeCellData(state: .goldMerchant, goldMerchant: val.goldMerchant, isOfficial: val.isOfficial))
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
    
    
    var shopTypeTVCell = ShopTypeTVCell()
    func makeCellShopType(table : UITableView, element : FilterShopTypeCellData, indexPath: IndexPath) -> UITableViewCell{
            self.shopTypeTVCell =  table.dequeueReusableCell(withIdentifier: ShopTypeTVCell.reuseIdentifier, for: indexPath) as! ShopTypeTVCell
            let temp = element
            self.shopTypeTVCell.selectionStyle = .none
            self.shopTypeTVCell.configureCell(with: temp)
            self.shopTypeTVCell.callbackTag = {
                value in
                if value == 0 {
                    var tempRelay = self.relayModel.value
                    if tempRelay.goldMerchant == SearchConstant.goldMerchant {
                        tempRelay.goldMerchant = 0
                    }else {
                        tempRelay.goldMerchant = SearchConstant.goldMerchant
                    }
                    self.relayGoldMerchant.accept((tempRelay.goldMerchant == 2))
                    self.relayModel.accept(tempRelay)
                }else {
                    var tempRelay = self.relayModel.value
                    tempRelay.isOfficial = !tempRelay.isOfficial
                    self.relayIsOfficial.accept(tempRelay.isOfficial)
                    self.relayModel.accept(tempRelay)
                }
            }
            return  self.shopTypeTVCell
       }
       
    
    
}


extension ShopTypeVM {
    func applyFilter(){
        var tempFilterData = self.relayModel.value
        if relayGoldMerchant.value {
            tempFilterData.goldMerchant = 2
        }else {
            tempFilterData.goldMerchant = 0
        }
        tempFilterData.isOfficial = relayIsOfficial.value
        self.relayModel.accept(tempFilterData)
        UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
      }
}
