//
//  ListOrdersInteractor.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 04/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation
protocol ListOrdersBusinessLogic {
    func fetchOrders(request: ListOrders.FetchOrders.Request)
}

protocol ListOrdersDataStore {
    var orders: [Order]? { get }
}

class ListOrdersInteractor: ListOrdersBusinessLogic, ListOrdersDataStore {
    var orders: [Order]?
    var ordersWorker = OrdersWorker(ordersStore: OrdersMemStore())
    var presenter: ListOrdersPresentationLogic?

    
    // MARK: - Fetch orders
    func fetchOrders(request: ListOrders.FetchOrders.Request) {
        ordersWorker.fetchOrders { (orders) -> Void in
            self.orders = orders
            let response = ListOrders.FetchOrders.Response(orders: orders)
            self.presenter?.presentFetchedOrders(response: response)
        }
    }
}
