//
//  ListOrdersInteractorTests.swift
//  CleanArchitectureTests
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import XCTest
@testable import CleanArchitecture
class ListOrdersInteractorTests: XCTestCase {

    // MARK: - Subject under test
    
    var sut: ListOrdersInteractor!

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        setupListOrdersInteractor()

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()

    }
    // MARK: - Test setup
    
    func setupListOrdersInteractor() {
        sut = ListOrdersInteractor()
    }
    
    
    // MARK: - Test doubles
    
    class ListOrdersPresentationLogicSpy: ListOrdersPresentationLogic {
        var presentFetchedOrdersCalled = false

        func presentFetchedOrders(response: ListOrders.FetchOrders.Response) {
            presentFetchedOrdersCalled = true
        }
        
        
        
    }
    class OrdersWorkerSpy: OrdersWorker {
        // MARK: Method call expectations
        
        var fetchOrdersCalled = false
        
        // MARK: Spied methods
        
        override func fetchOrders(completionHandler: @escaping ([Order]) -> Void)
        {
            fetchOrdersCalled = true
            completionHandler([Seeds.Orders.amy, Seeds.Orders.bob])
        }
    }

    func testFetchOrdersShouldAskOrdersWorkerToFetchOrdersAndPresenterToFormatResult()
    {
        // Given
        let listOrdersPresentationLogicSpy = ListOrdersPresentationLogicSpy()
        sut.presenter = listOrdersPresentationLogicSpy
        let ordersWorkerSpy = OrdersWorkerSpy(ordersStore: OrdersMemStore())
        sut.ordersWorker = ordersWorkerSpy
        
        // When
        let request = ListOrders.FetchOrders.Request()
        sut.fetchOrders(request: request)
        
        // Then
        XCTAssert(ordersWorkerSpy.fetchOrdersCalled, "FetchOrders() should ask OrdersWorker to fetch orders")
        XCTAssert(listOrdersPresentationLogicSpy.presentFetchedOrdersCalled, "FetchOrders() should ask presenter to format orders result")
    }

}
