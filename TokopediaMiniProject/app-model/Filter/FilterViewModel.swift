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
        let payloadModelTrigger = input.didSetPayloadTrigger.asDriver()
        let relayModel = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
        
       let payLoadProcess = payloadModelTrigger.flatMapLatest{
            value -> Driver<SearchViewModelData> in
            var temp = value
            temp.valMinPrice = 1919
            temp.valMaxPrice = 1919191919
            relayModel.accept(temp)
            return relayModel.asDriver()
        }
        
        
        return Output(
            cellData: payLoadProcess.asDriver()
        )
    }
    
   
}

