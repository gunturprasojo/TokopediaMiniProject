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
    
    var currentPageInquiry : Int = 0
    var lengthPageInquiry : Int = 10
}

class SearchViewModel: NSObject {
    
    let service : ProductServiceProtocol
    init(service : ProductServiceProtocol = ProductService()) {
        self.service = service
    }
    var servicePayload = SearchViewModelData()
    
    struct Input {
        let refreshTrigger : Driver<Void>
        let didLoadNextDataTrigger : Driver<Void>
        let filterData  : Driver<Void>
        let willDisplayCell : Driver<(cell: UICollectionViewCell, at: IndexPath)>
    }
    
    struct Output {
        let contactListCellData : Driver<[ProductListCollectionViewCellData]>
        let errorData : Driver<String>
        let isLoading : Driver<Bool>
        let isShowLoadMore : Driver<Bool>
        
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
        self.servicePayload.currentPageInquiry = 0
    }
    
    func paramsGenerator() {
        self.initUrl()
        self.exampleUrl += "product?"
        self.exampleUrl += "\(URLSearch.q)=\(servicePayload.valProduct)"
        self.exampleUrl += "&\(URLSearch.minPrice)=\(servicePayload.valMinPrice)"
        self.exampleUrl += "&\(URLSearch.maxPrice)=\(servicePayload.valMaxPrice)"
        self.exampleUrl += "&\(URLSearch.wholeSale)=\(servicePayload.wholeSale)"
        self.exampleUrl += "&\(URLSearch.fshop)=\(servicePayload.fShop)"
        self.exampleUrl += "&\(URLSearch.currentInquiry)=\(servicePayload.currentPageInquiry)"
        self.exampleUrl += "&\(URLSearch.lengthInquiry)=\(servicePayload.lengthPageInquiry)"
        
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
        let fetchNextDataTrigger = input.filterData.asDriver()
        
        let fetchDataTrigger = input.refreshTrigger.asDriver()
        let willDisplayTrigger = input.willDisplayCell.asDriver()
        
        let myFilter = BehaviorRelay<[ProductListCollectionViewCellData]>(value: [ProductListCollectionViewCellData]())
        

        //============= INITIAL DATA TRIGGER HANDLER
        let loadData = fetchDataTrigger.flatMapLatest{
            [service] _ -> Driver<[Product]> in
            self.servicePayload.currentPageInquiry = 0
            print("INITIAL")
            print("current inquiry : \(self.servicePayload.currentPageInquiry)")
            return service.fetchProducts(url: self.fetchUrl())
                .do(
                    onNext : {
                  val in
                    print("something next")
                    isLoading.accept(true)
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(false)
                    print("error fetch product")
                }, onCompleted:  {
                    print("something completed")
                })
                .asDriver{
                _ -> Driver<[Product]> in
                Driver.empty()
                }
            .do(
               onNext : {
                val in
                print("something doing")
                self.servicePayload.currentPageInquiry += 1
                myFilter.accept(val.map {
                    value in
                    self.isFirstLoad = false
                    return ProductListCollectionViewCellData(imageURL: value.imageUri, name: value.name, price: value.price)
                })
                isLoading.accept(false)
                })
        }
      
        //============= NEXT DATA TRIGGER HANDLER
        let loadNextData = willDisplayTrigger.flatMapLatest{
            [service] (cell,indexPath) -> Driver<[Product]> in
            if  indexPath.row >= (myFilter.value.count - 4) {
            print("NEXT INQUIRY")
            print("current next inquiry : \(self.servicePayload.currentPageInquiry)")
            return service.fetchProducts(url: self.fetchUrl())
                .do(
                    onNext : {
                  val in
                   
                    print("something on next")
                    isLoading.accept(true)
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoading.accept(false)
                    print("error fetch product")
                }, onCompleted:  {
                    print("something next completed")
                })
                .asDriver{
                _ -> Driver<[Product]> in
                Driver.empty()
                }
           .do(
               onNext : {
                val in
                print("something next doing")
                self.servicePayload.currentPageInquiry += 1
                myFilter.acceptAppending(val.map{
                    value in
                    return ProductListCollectionViewCellData(imageURL: value.imageUri, name: value.name, price: value.price)
                })
                isLoading.accept(false)
            })
            }else {
                return Driver.empty()
            }
        }
        
        
         //============= INITIAL DATA TRIGGER HANDLER
        let cellLoadData = loadData
            .map{
                products -> [ProductListCollectionViewCellData] in
                return products.map{
                    product  -> ProductListCollectionViewCellData in
                    ProductListCollectionViewCellData(imageURL: product.imageUri, name: product.name, price: product.price)
                }
        }
        
        myFilter.accept(cellLoadData.drive() as? [ProductListCollectionViewCellData] ?? [ProductListCollectionViewCellData]())
      
        
        //============= NEXT DATA TRIGGER HANDLER
        let cellLoadNextData = loadNextData
            .map{
               products -> [ProductListCollectionViewCellData] in
               return products.map{
                   product  -> ProductListCollectionViewCellData in
                   ProductListCollectionViewCellData(imageURL: product.imageUri, name: product.name, price: product.price)
            }
       }
        
        myFilter.acceptAppending(cellLoadNextData.drive() as? [ProductListCollectionViewCellData] ?? [ProductListCollectionViewCellData]())
        
        
        //=============
        let errorMessageDriver = errorMessage.asDriver(onErrorJustReturn: "").filter{
            $0.isEmpty
        }
        
        let onWillDisplay = willDisplayTrigger.do(
            onNext:
            {
                cell, index in
            }
        )
        
        let isShowLoadMore = onWillDisplay.map{
            temp -> Bool in
            let res = temp.at.row >= (myFilter.value.count - 4)
            if res {
//                self.isAbleToLoad = !self.isAbleToLoad
            }
            return temp.at.row >= (myFilter.value.count - 4)
        }
        
        
        
        //============= OUTPUT
        return Output(
            contactListCellData: myFilter.asDriver(),
            errorData: errorMessageDriver ,
            isLoading: isLoading.asDriver(),
            isShowLoadMore: isShowLoadMore.asDriver()
        )
    }
}
