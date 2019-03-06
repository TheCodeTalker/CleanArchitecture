//
//  ListOrderModel.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 25/02/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation
enum ListOrders {
    // MARK: Use cases
    enum FetchOrders
    {
        struct Request {
        }
        struct Response {
            var orders: [Order]
        }
        struct ViewModel {
            struct DisplayedOrder {
                var id: String
                var date: String
                var email: String
                var name: String
                var total: String
            }
            var displayedOrders: [DisplayedOrder]
        }
    }
}
