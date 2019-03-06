//
//  ListOrdersPresenterTests.swift
//  CleanArchitectureTests
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import XCTest
@testable import CleanArchitecture
class ListOrdersPresenterTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: ListOrdersPresenter!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        setupListOrdersPresenter()
    }
    // MARK: - Test setup
    
    func setupListOrdersPresenter() {
        sut = ListOrdersPresenter()
    }
    class ListOrdersDisplayLogicSpy:ListOrdersDisplayLogic {
        var viewModel: ListOrders.FetchOrders.ViewModel!
        var displayFetchedOrdersCalled = false

        func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel)
        {
            displayFetchedOrdersCalled = true
            self.viewModel = viewModel
        }
        
    }
    
   func testPresentFetchedOrdersShouldFormatFetchedOrdersForDisplay() {
    //Given
    let listOrdersDisplayLogicSpy = ListOrdersDisplayLogicSpy()
    sut.viewController = listOrdersDisplayLogicSpy
    
    //when
    var dateComponents = DateComponents()
    dateComponents.year = 2007
    dateComponents.month = 6
    dateComponents.day = 29
    let date = Calendar.current.date(from: dateComponents)!
    
    var amy = Seeds.Orders.amy
    amy.date = date
    let orders = [amy]

    let response = ListOrders.FetchOrders.Response(orders: orders)
    sut.presentFetchedOrders(response: response)
    
    // Then
    let displayedOrders = listOrdersDisplayLogicSpy.viewModel.displayedOrders
    for displayedOrder in displayedOrders {
        XCTAssertEqual(displayedOrder.id, "aaa111", "Presenting fetched orders should properly format order ID")
        XCTAssertEqual(displayedOrder.date, "6/29/07", "Presenting fetched orders should properly format order date")
        XCTAssertEqual(displayedOrder.email, "amy.apple@clean-swift.com", "Presenting fetched orders should properly format email")
        XCTAssertEqual(displayedOrder.name, "Amy Apple", "Presenting fetched orders should properly format name")
        XCTAssertEqual(displayedOrder.total, "$1.11", "Presenting fetched orders should properly format total")
    }
    }
    
    func testPresentFetchedOrdersShouldAskViewControllerToDisplayFetchedOrders()  {
        //Given
        let listOrdersDisplayLogicSpy = ListOrdersDisplayLogicSpy()
        sut.viewController = listOrdersDisplayLogicSpy
        
        //When
        let orders = [Seeds.Orders.amy]
        let response = ListOrders.FetchOrders.Response(orders: orders)
        sut.presentFetchedOrders(response: response)

    }
    
    

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
