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


struct SearchViewModelData {
    var valProduct : String = ""
    var valMinPrice : Int = 0
    var valMaxPrice : Int = 0
    var wholeSale : Bool = true
    var official : Bool = true
    var fShop : Int = 0
    
    var currentInquiry : Int = 0
    var lengthInquiry : Int = 10
}

class SearchViewModel: NSObject {
    
    let service : ProductServiceProtocol
    init(service : ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    var servicePayload = SearchViewModelData()
    
    struct Input {
        let didLoadTrigger : Driver<Void>
        let didTapCellTrigger : Driver<IndexPath>
        let fetchInitialData : Driver<Void>
        let fetchNextData : Driver<Void>
        let filterData  : Driver<Void>
    }
    
    struct Output {
        let contactListCellData : Driver<[ProductListCollectionViewCellData]>
        let errorData : Driver<String>
        let selectedIndex : Driver<(index : IndexPath, model : ProductListCollectionViewCellData)>
        let isLoading : Driver<Bool>
//        let fetchNextData : Driver<[ProductListCollectionViewCellData]>
    }
    
    var exampleUrl : String = ""
    let disposeBag = DisposeBag()
    
    func initUrl(){
        self.exampleUrl = BaseURLServ.baseUrl() + URLSearch.base + VersionSvc.version()
    }
    
    func initDummyPayload(){
        self.servicePayload.valProduct = "samsung"
        self.servicePayload.valMinPrice = 10000
        self.servicePayload.valMaxPrice = 100000
        self.servicePayload.wholeSale = true
        self.servicePayload.official = true
        self.servicePayload.currentInquiry = 0
    }
    
    func paramsGenerator() {
        self.initUrl()
        self.exampleUrl += "product?"
        self.exampleUrl += "\(URLSearch.q)=\(servicePayload.valProduct)"
        self.exampleUrl += "&\(URLSearch.minPrice)=\(servicePayload.valMinPrice)"
        self.exampleUrl += "&\(URLSearch.maxPrice)=\(servicePayload.valMaxPrice)"
        self.exampleUrl += "&\(URLSearch.wholeSale)=\(servicePayload.wholeSale)"
        self.exampleUrl += "&\(URLSearch.fshop)=\(servicePayload.fShop)"
        self.exampleUrl += "&\(URLSearch.currentInquiry)=\(servicePayload.currentInquiry)"
        self.exampleUrl += "&\(URLSearch.lengthInquiry)=\(servicePayload.lengthInquiry)"
        
    }
    
    var isFirstLoad = true
    func fetchUrl() -> String{
        self.initUrl()
        if isFirstLoad {
            self.initDummyPayload()
        }
        self.paramsGenerator()
        return self.exampleUrl
    }
    
    func transform(input: Input) -> Output {
        let errorMessage = PublishSubject<String>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let myFilter = BehaviorRelay<[ProductListCollectionViewCellData]>(value: [ProductListCollectionViewCellData]())
        let fetchNextDataTrigger = Driver.merge(input.filterData)
        let fetchDataTrigger = Driver.merge(input.didLoadTrigger , input.fetchInitialData)
     
         //=============
        let observablePayload = PublishSubject<SearchViewModelData>()
        
        //=============
        let loadData = fetchDataTrigger.flatMapLatest{
            [service] _ -> Driver<[Product]> in
            self.servicePayload.currentInquiry = 0
            print("current inquiry : \(self.servicePayload.currentInquiry)")
            return service.fetchProducts(url: self.fetchUrl())
                .do(
                    onNext : {
                      _ in
                       
                        self.isFirstLoad = false
                        isLoading.accept(true)
                      
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(false)
                    print("error fetch product")
                })
                .asDriver{
                _ -> Driver<[Product]> in
                Driver.empty()
                }
           .do(
               onNext : {
                val in
                myFilter.accept(val.map{
                    value in
                    return ProductListCollectionViewCellData(imageURL: value.imageUri, name: value.name, price: value.price)
                })
                isLoading.accept(false)
            })
        }
        
        
        let loadNextData = fetchNextDataTrigger.flatMapLatest{
            [service] _ -> Driver<[Product]> in
            self.servicePayload.currentInquiry += 1
            print("current inquiry : \(self.servicePayload.currentInquiry)")
            return service.fetchProducts(url: self.fetchUrl())
                .do(
                    onNext : {
                      _ in
                        self.isFirstLoad = false
                        isLoading.accept(true)
                      
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(false)
                    print("error fetch product")
                })
                .asDriver{
                _ -> Driver<[Product]> in
                Driver.empty()
                }
           .do(
               onNext : {
                val in
                myFilter.accept(myFilter.value + val.map{
                   value in
                   return ProductListCollectionViewCellData(imageURL: value.imageUri, name: value.name, price: value.price)
               })
               isLoading.accept(false)
            })
        }
       
        
        
       

        //=============
        let contactListCellData = loadData
            .map{
                products -> [ProductListCollectionViewCellData] in
                return products.map{
                    product  -> ProductListCollectionViewCellData in
                    ProductListCollectionViewCellData(imageURL: product.imageUri, name: product.name, price: product.price)
                }
        }
        
        _ = loadNextData
                .map{
               products -> [ProductListCollectionViewCellData] in
               return products.map{
                   product  -> ProductListCollectionViewCellData in
                   ProductListCollectionViewCellData(imageURL: product.imageUri, name: product.name, price: product.price)
                }
        }
    
        
       _ = observablePayload.subscribe(
                 onNext: {
                 value in
                    self.isFirstLoad = false
                    self.servicePayload = value
                    print(self.servicePayload.currentInquiry)
                    
            }
        )
        
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
        
        return Output(
            contactListCellData: myFilter.asDriver(),
            errorData: errorMessageDriver ,
            selectedIndex: selectedIndexCell,
            isLoading: isLoading.asDriver()
//            fetchNextData: contactListCellNextData
        )
    }
}
