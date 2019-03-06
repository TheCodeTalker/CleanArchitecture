//
//  CreateOrderModels.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation

enum CreateOrder
{
    struct OrderFormFields
    {
        // MARK: Contact info
        var firstName: String
        var lastName: String
        var phone: String
        var email: String
        
        // MARK: Misc
        var id: String?
        var date: Date
        var total: NSDecimalNumber
    }
    
    // MARK: Use cases
    
    enum FormatExpirationDate
    {
        struct Request
        {
            var date: Date
        }
        struct Response
        {
            var date: Date
        }
        struct ViewModel
        {
            var date: String
        }
    }
    
    enum CreateOrder
    {
        struct Request
        {
            var orderFormFields: OrderFormFields
        }
        struct Response
        {
            var order: Order?
        }
        struct ViewModel
        {
            var order: Order?
        }
    }
    
    enum EditOrder
    {
        struct Request
        {
        }
        struct Response
        {
            var order: Order
        }
        struct ViewModel
        {
            var orderFormFields: OrderFormFields
        }
    }
    
    enum UpdateOrder
    {
        struct Request
        {
            var orderFormFields: OrderFormFields
        }
        struct Response
        {
            var order: Order?
        }
        struct ViewModel
        {
            var order: Order?
        }
    }
}
