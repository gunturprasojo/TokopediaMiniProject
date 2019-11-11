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
         let cellData : Driver<SearchViewModelData>
    }
    //============ Business Process
    
    
    var servicePayload = SearchViewModelData()
    let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        let payloadModel = input.didSetPayloadTrigger.asDriver()
        
        let cellDataShopCriteria = payloadModel.flatMapLatest{
            value -> Driver<SearchViewModelData> in
            let relayModel = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
            relayModel.accept(value)
            return relayModel.asDriver()
        }
        
        
        return Output(
            cellData: cellDataShopCriteria.asSharedSequence()
        )
    }
    
   
}

