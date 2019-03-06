//
//  ShowOrderInteractor.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import UIKit

protocol ShowOrderBusinessLogic
{
    func getOrder(request: ShowOrder.GetOrder.Request)
}

protocol ShowOrderDataStore
{
    var order: Order! { get set }
}

class ShowOrderInteractor: ShowOrderBusinessLogic, ShowOrderDataStore
{
    var presenter: ShowOrderPresentationLogic?
    
    var order: Order!
    
    // MARK: - Get order
    
    func getOrder(request: ShowOrder.GetOrder.Request)
    {
        let response = ShowOrder.GetOrder.Response(order: order)
        presenter?.presentOrder(response: response)
    }
}
