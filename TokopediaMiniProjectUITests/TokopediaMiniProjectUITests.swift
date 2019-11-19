//
//  TokopediaMiniProjectUITests.swift
//  TokopediaMiniProjectUITests
//
//  Created by Guntur Budi on 07/11/19.
//  Copyright © 2019 Guntur Budi. All rights reserved.
//

import XCTest

class TokopediaMiniProjectUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        self.testSearchVC(app)
       
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSearchVC(_ app : XCUIApplication){
        XCTAssertTrue(app.buttons[MockSearchVC.btnFilter].exists)
        XCTAssertTrue(app.staticTexts[MockSearchVC.searchTitle].exists)
        XCTAssertTrue(app.collectionViews[MockSearchVC.collectionSearchVC].exists)
        app.buttons[MockSearchVC.btnFilter].tap()
        self.testFilterVC(app)
    }
    
    func testFilterVC(_ app : XCUIApplication){
        XCTAssertTrue(app.buttons[MockFilterVC.btnApply].exists)
        XCTAssertTrue(app.buttons[">"].exists)
        app.buttons[">"].tap()
        self.testShopTypeVC(app)
    }
    
    func testShopTypeVC(_ app : XCUIApplication){
        XCTAssertTrue(app.buttons[MockShopTypeVC.btnApply].exists)
    }
    
}


class MockSearchVC {
    //SearchVC
    static let collectionSearchVC = "collSearchVC"
    static let btnFilter = "Filter"
    static let searchTitle = "Search"
}


class MockFilterVC {
    //FilterVC
    static let btnApply = "Apply"
}


class MockShopTypeVC {
    //FilterVC
    static let btnApply = "Apply"
}
