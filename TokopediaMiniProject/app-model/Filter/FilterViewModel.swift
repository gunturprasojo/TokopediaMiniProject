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
    }
    
    struct Output {
//        let filterCellData : Driver<([FilterShopCriteriaCellData],[FilterShopTypeCellData])>
        let filterShopCriteriaData : Driver<[FilterShopCriteriaCellData]>
//        let filterCellData2 : Driver<[FilterShopTypeCellData]>
        
    }
    //============ Business Process
    
    
    var servicePayload = SearchViewModelData()
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let payloadModel = input.didSetPayloadTrigger.asDriver()
       
        let cellDataShopCriteria = payloadModel.flatMapLatest{
            value -> Driver<[FilterShopCriteriaCellData]> in
            let relayCriterias = BehaviorRelay<[FilterShopCriteriaCellData]>(value: [FilterShopCriteriaCellData]())
            let valCriteria = FilterShopCriteriaCellData(maxPrice: value.valMaxPrice,
                                                         minPrice: value.valMinPrice,
                                                         isWholeSale: value.wholeSale)
            relayCriterias.accept([valCriteria])
            return relayCriterias.asDriver()
        }
        .asDriver{
        _ -> Driver<[FilterShopCriteriaCellData]> in
            Driver.empty()
        }
        
        
        return Output(
            filterShopCriteriaData: cellDataShopCriteria.asDriver()
        )
    }
    
   
}

