//
//  ShowOrderModels.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation
import UIKit

enum ShowOrder
{
    // MARK: Use cases
    
    enum GetOrder
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
            struct DisplayedOrder
            {
                var id: String
                var date: String
                var email: String
                var name: String
                var total: String
            }
            var displayedOrder: DisplayedOrder
        }
    }
}
