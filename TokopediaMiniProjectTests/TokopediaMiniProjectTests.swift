//
//  TokopediaMiniProjectTests.swift
//  TokopediaMiniProjectTests
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import XCTest
@testable import TokopediaMiniProject

class TokopediaMiniProjectTests: XCTestCase {
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

import RxSwift

class Test : XCTestCase {
    
    var service = ProductService()
    var viewModel = SearchVM()
    var searchVC = SearchVC()
    let disposeBag = DisposeBag()
    
    override func setUp() {
        super.setUp()
        self.service = ProductService()
        self.viewModel = SearchVM(service: service)
    }
    
    func testFetchData(){
        searchVC.refreshControl.rx.base.sendActions(for: .valueChanged)
    }
    
    
    func testSetupViewModel(){
        let input = SearchVM.Input(
            refreshTrigger: searchVC.refreshControl.rx.controlEvent(.allEvents).asDriver(),
            didLoadNextDataTrigger: searchVC.buttonFilter.rx.controlEvent(.touchUpInside).asDriver(),
            navigateToFilter: searchVC.buttonFilter.rx.controlEvent(.touchUpInside).asDriver(),
            willDisplayCell: searchVC.collectionView.rx.willDisplayCell.asDriver()
        )
        
        let output = self.viewModel.transform(input: input)
          
        output.productListCellData.drive(
            onNext : {
                value in
                for i in value {
                    print("fetched value : \(i.name)")
                }
            }
        ).disposed(by: disposeBag)

        output.errorData.drive(onNext:
              { errorMessage in print("") })
              .disposed(by: disposeBag)
          
        output.isLoading.drive(searchVC.refreshControl.rx.isRefreshing).disposed(by: disposeBag)

        output.isShowLoadMore.drive(
           onNext : {
               isLoadMore in
            
           }
        ).disposed(by: disposeBag)

        output.navigateToFilter.drive(
           onNext: {

           }
        ).disposed(by: disposeBag)

        output.loadDataFromFilter.drive(
           onNext : {
               value in
               print("loaded : \(value.valProduct)")
           }
        ).disposed(by: disposeBag)
    }
    
    
    
}
