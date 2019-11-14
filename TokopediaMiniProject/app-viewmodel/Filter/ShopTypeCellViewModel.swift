//
//  ShopTypeCellViewModel.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 13/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources


class ShopTypeCellModel: NSObject {
    
    //============ Business Process
    struct Input {
        let didSetShopTypeCellData : Driver<FilterShopTypeCellData>
    }
    
    struct Output {
        let shopTypeCellData : Driver<[SectionFilterShopTypeCellData]>
        
    }
    //============ Business Process
    
    let shopTypeVC = ShopTypeVC()
    
    
    let service : ProductServiceProtocol
       init(service : ProductServiceProtocol = ProductService()) {
           self.service = service
       }
  
    
    func transform(input: Input) -> Output {
        let relayShopTypeCellData = BehaviorRelay<[SectionFilterShopTypeCellData]>(value:[SectionFilterShopTypeCellData]())
        let payloadModelTrigger = input.didSetShopTypeCellData.asDriver()
         
        let payLoadProcess = payloadModelTrigger.flatMapLatest{
             value -> Driver<[SectionFilterShopTypeCellData]> in
            
            let sections = [SectionFilterShopTypeCellData(items: [FilterShopTypeCellData(goldMerchant: 0, isOfficial: false)])]
            
            let sections2 = [SectionFilterShopTypeCellData(items: [FilterShopTypeCellData(goldMerchant: 200, isOfficial: false)])]
            
            relayShopTypeCellData.accept(sections)
            relayShopTypeCellData.acceptAppending(sections2)
         return relayShopTypeCellData.asDriver()
         }
        
        //============= OUTPUT
        return Output(
            shopTypeCellData : payLoadProcess.asDriver()
        )
    }
    
    
    private func navigateToFilter(){
        UIApplication.topViewController()?.navigationController?.pushViewController(shopTypeVC, animated: true)
    }
}

