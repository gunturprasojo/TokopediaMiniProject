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


class FilterShopTypeCellVM: NSObject {

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

          
            let sectionGoldMerchant = [SectionFilterShopTypeCellData(items: [FilterShopTypeCellData(state : .goldMerchant,goldMerchant: value.goldMerchant, isOfficial: value.isOfficial)])]
          

            let sectionOfficial = [SectionFilterShopTypeCellData(items: [FilterShopTypeCellData(state: .official ,goldMerchant: value.goldMerchant, isOfficial: value.isOfficial)])]

            if value.goldMerchant == 2 {
            relayShopTypeCellData.accept(sectionGoldMerchant)
            }
            
            if value.isOfficial {
            relayShopTypeCellData.acceptAppending(sectionOfficial)
            }
            
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

