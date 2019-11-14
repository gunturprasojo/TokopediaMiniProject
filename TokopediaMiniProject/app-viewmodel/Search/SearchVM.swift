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
    var valProduct : String = "samsung"
    var valMinPrice : Int = 10000
    var valMaxPrice : Int = 100000
    var wholeSale : Bool = true
    var official : Bool = true
    var fShop : Int = 2
    var currentPageInquiry : Int = 0
    var lengthPageInquiry : Int = 10
}

class SearchVM: NSObject {
    
    //============ Business Process
    struct Input {
        let refreshTrigger : Driver<Void>
        let didLoadNextDataTrigger : Driver<Void>
        let navigateToFilter  : Driver<Void>
        let willDisplayCell : Driver<(cell: UICollectionViewCell, at: IndexPath)>
    }
    
    struct Output {
        let productListCellData : Driver<[ProductListCollectionViewCellData]>
        let errorData : Driver<String>
        let isLoading : Driver<Bool>
        let isShowLoadMore : Driver<Bool>
        let navigateToFilter : Driver<Void>
        let loadDataFromFilter : Driver<SearchViewModelData>
        
    }
    //============ Business Process
    
    
    
    
    let service : ProductServiceProtocol
       init(service : ProductServiceProtocol = ProductService()) {
           self.service = service
       }
    var servicePayload = SearchViewModelData()
    var exampleUrl : String = ""
    let disposeBag = DisposeBag()
    let filterVC = FilterVC()
    
    
    func initUrl(){
        self.exampleUrl = BaseURLServ.baseUrl() + URLSearch.base + VersionSvc.version()
    }
    
    func paramsGenerator() {
        self.initUrl()
        self.exampleUrl += "product?"
        self.exampleUrl += "\(URLSearch.q)=\(servicePayload.valProduct)"
        self.exampleUrl += "&\(URLSearch.minPrice)=\(servicePayload.valMinPrice)"
        self.exampleUrl += "&\(URLSearch.maxPrice)=\(servicePayload.valMaxPrice)"
        self.exampleUrl += "&\(URLSearch.wholeSale)=\(servicePayload.wholeSale)"
        self.exampleUrl += "&\(URLSearch.official)=\(servicePayload.official)"
        self.exampleUrl += "&\(URLSearch.fshop)=\(servicePayload.fShop)"
        self.exampleUrl += "&\(URLSearch.currentInquiry)=\(servicePayload.currentPageInquiry)"
        self.exampleUrl += "&\(URLSearch.lengthInquiry)=\(servicePayload.lengthPageInquiry)"
        
    }
    
    func fetchUrl() -> String{
        self.initUrl()
        self.paramsGenerator()
        return self.exampleUrl
    }
    
    func transform(input: Input) -> Output {
        let errorMessage = PublishSubject<String>()
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let filterDataTrigger = input.navigateToFilter.asDriver()
        let fetchDataTrigger = input.refreshTrigger.asDriver()
        let willDisplayTrigger = input.willDisplayCell.asDriver()
        let cellDataRelay = BehaviorRelay<[ProductListCollectionViewCellData]>(value: [ProductListCollectionViewCellData]())
      

        //============= INITIAL DATA TRIGGER HANDLER
        let loadData = fetchDataTrigger.flatMapLatest{
            [service] _ -> Driver<[Product]> in
            self.servicePayload.currentPageInquiry = 0
            return service.fetchProducts(url: self.fetchUrl())
                .do(
                    onNext : {
                  val in
                    print("soemthing on next")
                    isLoadingRelay.accept(true)
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoadingRelay.accept(false)
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
                print("something doing on next")
                self.servicePayload.currentPageInquiry += 1
                cellDataRelay.accept(val.map {
                    value in
                    return ProductListCollectionViewCellData(imageURL: value.imageUri, name: value.name, price: value.price)
                })
                isLoadingRelay.accept(false)
                })
        }
      
        //============= NEXT DATA TRIGGER HANDLER
        let loadNextData = willDisplayTrigger.flatMapLatest{
            [service] (cell,indexPath) -> Driver<[Product]> in
            if  indexPath.row >= (cellDataRelay.value.count - 4) {
            return service.fetchProducts(url: self.fetchUrl())
                .do(
                    onNext : {
                  val in
                    isLoadingRelay.accept(true)
                },
                onError: {
                    error in
                    errorMessage.onNext(error.localizedDescription)
                    isLoadingRelay.accept(false)
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
                self.servicePayload.currentPageInquiry += 1
                cellDataRelay.acceptAppending(val.map{
                    value in
                    return ProductListCollectionViewCellData(imageURL: value.imageUri, name: value.name, price: value.price)
                })
                isLoadingRelay.accept(false)
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
        
        cellDataRelay.accept(cellLoadData.drive() as? [ProductListCollectionViewCellData] ?? [ProductListCollectionViewCellData]())
        
        //============= NEXT DATA TRIGGER HANDLER
        let cellLoadNextData = loadNextData
            .map{
               products -> [ProductListCollectionViewCellData] in
               return products.map{
                   product  -> ProductListCollectionViewCellData in
                   ProductListCollectionViewCellData(imageURL: product.imageUri, name: product.name, price: product.price)
            }
       }
        
        cellDataRelay.acceptAppending(cellLoadNextData.drive() as? [ProductListCollectionViewCellData] ?? [ProductListCollectionViewCellData]())
        
        //=============
        let errorMessageDriver = errorMessage.asDriver(onErrorJustReturn: "").filter{
            $0.isEmpty
        }
        
        
        let isShowLoadMore = willDisplayTrigger.map{
            temp -> Bool in
            let res = temp.at.row >= (cellDataRelay.value.count - 4)
            if res {
            }
            return temp.at.row >= (cellDataRelay.value.count - 4)
        }
        
        let navigateToFilter = filterDataTrigger.do(
            onNext: {
                self.navigateToFilter()
            }
        ).asDriver()
        
        let filterPayloadData = filterVC.viewModel.callbackPayload.do(
            onNext: {
            callbackValue in
                 isLoadingRelay.accept(true)
                self.servicePayload = callbackValue
                cellDataRelay.accept([ProductListCollectionViewCellData]())
            }
            
        ).asDriver(onErrorJustReturn: SearchViewModelData())
      
        
        //============= OUTPUT
        return Output(
            productListCellData: cellDataRelay.asDriver(),
            errorData: errorMessageDriver ,
            isLoading: isLoadingRelay.asDriver(),
            isShowLoadMore: isShowLoadMore.asDriver(),
            navigateToFilter: navigateToFilter,
            loadDataFromFilter: filterPayloadData
        )
    }
    
    
    private func navigateToFilter(){
        filterVC.viewModelPayLoad.accept(servicePayload)
        UIApplication.topViewController()?.navigationController?.pushViewController(filterVC, animated: true)
    }
}

