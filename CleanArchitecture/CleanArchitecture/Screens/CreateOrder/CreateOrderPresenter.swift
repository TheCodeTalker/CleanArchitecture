//
//  CreateOrderPresenter.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation
import UIKit

protocol CreateOrderPresentationLogic
{
    func presentExpirationDate(response: CreateOrder.FormatExpirationDate.Response)
    func presentCreatedOrder(response: CreateOrder.CreateOrder.Response)
    func presentOrderToEdit(response: CreateOrder.EditOrder.Response)
    func presentUpdatedOrder(response: CreateOrder.UpdateOrder.Response)
}

class CreateOrderPresenter: CreateOrderPresentationLogic
{
    weak var viewController: CreateOrderDisplayLogic?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()
    
    // MARK: - Expiration date
    
    func presentExpirationDate(response: CreateOrder.FormatExpirationDate.Response)
    {
        let date = dateFormatter.string(from: response.date)
        let viewModel = CreateOrder.FormatExpirationDate.ViewModel(date: date)
        viewController?.displayExpirationDate(viewModel: viewModel)
    }
    
    // MARK: - Create order
    
    func presentCreatedOrder(response: CreateOrder.CreateOrder.Response)
    {
        let viewModel = CreateOrder.CreateOrder.ViewModel(order: response.order)
        viewController?.displayCreatedOrder(viewModel: viewModel)
    }
    
    // MARK: - Edit order
    
    func presentOrderToEdit(response: CreateOrder.EditOrder.Response)
    {
        let orderToEdit = response.order
        let viewModel = CreateOrder.EditOrder.ViewModel(
            orderFormFields: CreateOrder.OrderFormFields(
                firstName: orderToEdit.firstName,
                lastName: orderToEdit.lastName,
                phone: orderToEdit.phone,
                email: orderToEdit.email,
                id: orderToEdit.id,
                date: orderToEdit.date,
                total: orderToEdit.total
            )
        )
        viewController?.displayOrderToEdit(viewModel: viewModel)
    }
    
    // MARK: - Update order
    
    func presentUpdatedOrder(response: CreateOrder.UpdateOrder.Response)
    {
        let viewModel = CreateOrder.UpdateOrder.ViewModel(order: response.order)
        viewController?.displayUpdatedOrder(viewModel: viewModel)
    }
}
