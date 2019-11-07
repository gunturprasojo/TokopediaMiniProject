//
//  SearchViewModel.swift
//  TokopediaMiniProject
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

struct SearchServicePayload {
    var valProduct : String
    var valMinPrice : Int
    var maxPrice : Int
    var wholeSale : Bool
    var official : Bool
    var fShop : Int
    
    var currentInquiry : Int
    var lengthInquiry : Int
}

class SearchViewModel: NSObject {
    
    let service : ProductServiceProtocol
    init(service : ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    
    struct Input {
        let didLoadTrigger : Driver<Void>
        let didTapCellTrigger : Driver<IndexPath>
        let pullToRefreshTrigger : Driver<Void>
    }
    
    struct Output {
        let contactListCellData : Driver<[ProductListCollectionViewCellData]>
        let errorData : Driver<String>
        let selectedIndex : Driver<(index : IndexPath, model : ProductListCollectionViewCellData)>
        let isLoading : Driver<Bool>
    }
    
    let exampleUrl = "https://ace.tokopedia.com/search/v2.5/product?q=samsung&pmin=10000&pmax=100000&wholesale=true&official=true&fshop=2&start=0&rows=10"
    
    func transform(input: Input) -> Output {
       let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let fetchDataTrigger = Driver.merge(input.didLoadTrigger , input.pullToRefreshTrigger)
        
        
        //=============
       let fetchData = fetchDataTrigger.flatMapLatest{
            [service] _ -> Driver<[Product]> in
        service.fetchProducts(url: self.exampleUrl)
//            service.reactiveFetchContacts()
                .do(
                    onNext : {
                      _ in
                        isLoading.accept(true)
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(false)
                    print("error fetch product")
                } )
            .asDriver{
                _ -> Driver<[Product]> in
                Driver.empty()
            }
           .do(
               onNext : {
                 _ in
                   isLoading.accept(false)
           })
        }
        
        
        //=============
        let contactListCellData = fetchData
            .map{
            products -> [ProductListCollectionViewCellData] in
                products.map{
                  product  -> ProductListCollectionViewCellData in
                    ProductListCollectionViewCellData(imageURL: product.imageUri, name: product.name, price: product.price)
                }
        }
        
        //=============
        let errorMessageDriver = errorMessage.asDriver(onErrorJustReturn: "").filter{
            $0.isEmpty
        }
        
        //=============
        let selectedIndexCell = input
            .didTapCellTrigger
            .withLatestFrom(contactListCellData) {
            (index , contacts) ->
            (index: IndexPath , model : ProductListCollectionViewCellData) in
            return (index : index, model: contacts[index.row])
        }
        
        return Output(contactListCellData: contactListCellData, errorData: errorMessageDriver , selectedIndex: selectedIndexCell,isLoading: isLoading.asDriver() )
    }
}
