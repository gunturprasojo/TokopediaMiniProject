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
        let payloadModel = input.didSetPayloadTrigger.asDriver(onErrorJustReturn: SearchViewModelData())
        let relayModel = BehaviorRelay<SearchViewModelData>(value: SearchViewModelData())
        
       _ = payloadModel.flatMapLatest{
            value -> Driver<SearchViewModelData> in
            var temp = value
            temp.valMaxPrice = 2500
            relayModel.accept(temp)
            return relayModel.asDriver()
        }
        
        return Output(
            cellData: relayModel.asDriver()
        )
    }
    
   
}

