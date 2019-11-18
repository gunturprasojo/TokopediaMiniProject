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

    func transform(input: Input) -> Output {
        let payloadModelTrigger = input.didSetPayloadTrigger.asDriver()
        let resetModelTrigger = input.resetPayloadTrigger.asDriver()
        
        var payLoadProcess = payloadModelTrigger.flatMapLatest{
                  value -> Driver<FilterShopTypeCellData> in
                  self.relayModel.accept(value)
                  return self.relayModel.asDriver()
        }
        
        payLoadProcess = resetModelTrigger.flatMapLatest{
                   val -> Driver<FilterShopTypeCellData> in
            
            self.relayModel.accept(FilterShopTypeCellData(state: .goldMerchant, goldMerchant: SearchConstant.goldMerchant, isOfficial: SearchConstant.offical))
            return self.relayModel.asDriver()
                   
       }
              
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
                    var tempData = self.relayModel.value
                    if tempData.goldMerchant == SearchConstant.goldMerchant {
                        tempData.goldMerchant = 0
                    }else {
                        tempData.goldMerchant = SearchConstant.goldMerchant
                    }
                    self.relayModel.accept(tempData)
                }else {
                    var tempData = self.relayModel.value
                    tempData.isOfficial = !tempData.isOfficial
                    self.relayModel.accept(tempData)
                }
                
            }
           return  self.shopTypeTVCell
       }
       
    
    
}


extension ShopTypeVM {
 
}
