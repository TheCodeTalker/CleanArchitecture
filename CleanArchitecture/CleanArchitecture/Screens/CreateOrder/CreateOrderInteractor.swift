//
//  CreateOrderInteractor.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation
protocol CreateOrderBusinessLogic {
    var shippingMethods: [String] { get }
    var orderToEdit: Order? { get }
    func formatExpirationDate(request: CreateOrder.FormatExpirationDate.Request)
    func createOrder(request: CreateOrder.CreateOrder.Request)
    func showOrderToEdit(request: CreateOrder.EditOrder.Request)
    func updateOrder(request: CreateOrder.UpdateOrder.Request)
}
protocol CreateOrderDataStore {
    var orderToEdit: Order? { get set }
}
class CreateOrderInteractor: CreateOrderBusinessLogic,CreateOrderDataStore {
    var presenter: CreateOrderPresentationLogic?
    
    var ordersWorker = OrdersWorker(ordersStore: OrdersMemStore())
    var orderToEdit: Order?
    
    var shippingMethods = [
        ShipmentMethod(speed: .Standard).toString(),
        ShipmentMethod(speed: .OneDay).toString(),
        ShipmentMethod(speed: .TwoDay).toString()
    ]
    
    // MARK: - Expiration date
    
    func formatExpirationDate(request: CreateOrder.FormatExpirationDate.Request)
    {
        let response = CreateOrder.FormatExpirationDate.Response(date: request.date)
        presenter?.presentExpirationDate(response: response)
    }
    
    // MARK: - Create order
    
    func createOrder(request: CreateOrder.CreateOrder.Request)
    {
        let orderToCreate = buildOrderFromOrderFormFields(request.orderFormFields)
        
        ordersWorker.createOrder(orderToCreate: orderToCreate) { (order: Order?) in
            self.orderToEdit = order
            let response = CreateOrder.CreateOrder.Response(order: order)
            self.presenter?.presentCreatedOrder(response: response)
        }
    }
    
    // MARK: - Edit order
    
    func showOrderToEdit(request: CreateOrder.EditOrder.Request)
    {
        if let orderToEdit = orderToEdit {
            let response = CreateOrder.EditOrder.Response(order: orderToEdit)
            presenter?.presentOrderToEdit(response: response)
        }
    }
    
    // MARK: - Update order
    
    func updateOrder(request: CreateOrder.UpdateOrder.Request)
    {
        let orderToUpdate = buildOrderFromOrderFormFields(request.orderFormFields)
        
        ordersWorker.updateOrder(orderToUpdate: orderToUpdate) { (order) in
            self.orderToEdit = order
            let response = CreateOrder.UpdateOrder.Response(order: order)
            self.presenter?.presentUpdatedOrder(response: response)
        }
    }
    
    // MARK: - Helper function
    
    private func buildOrderFromOrderFormFields(_ orderFormFields: CreateOrder.OrderFormFields) -> Order
    {
        let billingAddress = Address(street1: "", street2: "", city: "", state: "", zip: "")
        
        let paymentMethod = PaymentMethod(creditCardNumber: "", expirationDate: Date.init(), cvv: "")
        
        let shipmentAddress = Address(street1: "", street2: "", city: "", state: "", zip: "")
        
        let shipmentMethod = ShipmentMethod(speed: ShipmentMethod.ShippingSpeed(rawValue: 0)!)
        
        return Order(firstName: orderFormFields.firstName, lastName: orderFormFields.lastName, phone: orderFormFields.phone, email: orderFormFields.email, billingAddress: billingAddress, paymentMethod: paymentMethod, shipmentAddress: shipmentAddress, shipmentMethod: shipmentMethod, id: orderFormFields.id, date: orderFormFields.date, total: orderFormFields.total)
    }
}
