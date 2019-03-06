//
//  ListOrdersViewControllerTests.swift
//  CleanArchitectureTests
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import XCTest
@testable import CleanArchitecture

class ListOrdersViewControllerTests: XCTestCase {

    // MARK: - Subject under test
    var sut: ListViewController!
    var window: UIWindow!

    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
        window = UIWindow()
        setupListOrdersViewController()
    }
    func setupListOrdersViewController()  {
        let bundle = Bundle.main
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        sut = storyboard.instantiateViewController(withIdentifier: "ListViewController") as? ListViewController
    }
    
    func loadView() {
        window.addSubview(sut.view)
        RunLoop.current.run(until: Date())
    }
    
    // MARK: - Test doubles
    
    class ListOrdersBusinessLogicSpy: ListOrdersBusinessLogic
    {
        var orders: [Order]?
        
        // MARK: Method call expectations
        
        var fetchOrdersCalled = false
        
        // MARK: Spied methods
        
        func fetchOrders(request: ListOrders.FetchOrders.Request)
        {
            fetchOrdersCalled = true
        }
    }
    
    class TableViewSpy: UITableView
    {
        // MARK: Method call expectations
        
        var reloadDataCalled = false
        
        // MARK: Spied methods
        
        override func reloadData()
        {
            reloadDataCalled = true
        }
    }
    
    func testShouldDisplayFetchedOrders()  {
        //Given
        let  tableViewSpy = TableViewSpy()
        sut.tableView = tableViewSpy
        
        // When
        let displayedOrders = [ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: "abc123", date: "6/29/07", email: "amy.apple@clean-swift.com", name: "Amy Apple", total: "$1.23")]
        let viewModel = ListOrders.FetchOrders.ViewModel(displayedOrders: displayedOrders)
        sut.displayFetchedOrders(viewModel: viewModel)

        // Then
        XCTAssert(tableViewSpy.reloadDataCalled, "Displaying fetched orders should reload the table view")
        
    }
    
    func testNumberOfSectionsInTableViewShouldAlwaysBeOne()  {
       //Given
        let tableview = sut.tableView
        
        //When
        let numberOfSections = sut.numberOfSections(in: tableview!)

        //Then
        XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")

    }
    
    func testNumberOfRowsInAnySectionShouldEqaulNumberOfOrdersToDisplay()  {
        // Given
        let tableView = sut.tableView
        let testDisplayedOrders = [ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: "abc123", date: "6/29/07", email: "amy.apple@clean-swift.com", name: "Amy Apple", total: "$1.23")]
        sut.displayedOrders = testDisplayedOrders
        
        // When
        let numberOfRows = sut.tableView(tableView!, numberOfRowsInSection: 0)
        
        // Then
        XCTAssertEqual(numberOfRows, testDisplayedOrders.count, "The number of table view rows should equal the number of orders to display")
    }
    
    
    func testShouldConfigureTableViewCellToDisplayOrder()
    {
        // Given
        let tableView = sut.tableView
        let testDisplayedOrders = [ListOrders.FetchOrders.ViewModel.DisplayedOrder(id: "abc123", date: "6/29/07", email: "amy.apple@clean-swift.com", name: "Amy Apple", total: "$1.23")]
        sut.displayedOrders = testDisplayedOrders
        
        // When
        let indexPath = IndexPath(row: 0, section: 0)
        let cell = sut.tableView(tableView!, cellForRowAt: indexPath)
        
        // Then
        XCTAssertEqual(cell.textLabel?.text, "6/29/07", "A properly configured table view cell should display the order date")
        XCTAssertEqual(cell.detailTextLabel?.text, "$1.23", "A properly configured table view cell should display the order total")
    }
    
    
    func testShouldFetchOrdersWhenViewDidAppear()  {
        let listOrdersBusinessLogicSpy = ListOrdersBusinessLogicSpy()
        sut.interactor = listOrdersBusinessLogicSpy
        loadView()
        
        // When
        sut.viewDidAppear(true)

        // Then
        XCTAssert(listOrdersBusinessLogicSpy.fetchOrdersCalled, "Should fetch orders right after the view appears")
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
