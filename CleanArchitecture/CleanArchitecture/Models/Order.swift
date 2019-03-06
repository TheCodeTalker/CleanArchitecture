//
//  Order.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 04/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation

struct Order : Equatable {
    //MARK: Contact info
    var firstName: String
    var lastName: String
    var phone: String
    var email: String
    
    // MARK: Payment info
    var billingAddress: Address
    var paymentMethod: PaymentMethod
    
    // MARK: Shipping info
    var shipmentAddress: Address
    var shipmentMethod: ShipmentMethod
    
    //MARK: Misc
    var id: String?
    var date: Date
    var total: NSDecimalNumber
    static func == (lhs: Order, rhs: Order) -> Bool{
      return  lhs.firstName == rhs.firstName
            && lhs.lastName == rhs.lastName
            && lhs.phone == rhs.phone
            && lhs.email == rhs.email
            && lhs.billingAddress == rhs.billingAddress
            && lhs.paymentMethod == rhs.paymentMethod
            && lhs.shipmentAddress == rhs.shipmentAddress
            && lhs.shipmentMethod == rhs.shipmentMethod
            && lhs.id == rhs.id
            && lhs.date.timeIntervalSince(rhs.date) < 1.0
            && lhs.total == rhs.total
    }
}

struct PaymentMethod: Equatable{
    var creditCardNumber: String
    var expirationDate: Date
    var cvv: String
    
 static func ==(lhs: PaymentMethod, rhs: PaymentMethod) -> Bool {
        return lhs.creditCardNumber == rhs.creditCardNumber
            && lhs.expirationDate.timeIntervalSince(rhs.expirationDate) < 1.0
            && lhs.cvv == rhs.cvv
    }
}

struct Address: Equatable {
    var street1: String
    var street2: String?
    var city: String
    var state: String
    var zip: String
}

struct ShipmentMethod {
    enum ShippingSpeed:Int {
        case Standard = 0 // "Standard Shipping"
        case OneDay = 1 // "One-Day Shipping"
        case TwoDay = 2 // "Two-Day Shipping"
    }
    var speed: ShippingSpeed
    func toString() ->  String {
        switch speed {
        case .Standard:
            return "Standard Shipping"
        case .OneDay:
            return "One-Day Shipping"
        case .TwoDay:
            return "Two-Day Shipping"
        }
    }
  static func ==(lhs: ShipmentMethod, rhs: ShipmentMethod) -> Bool {
        return lhs.speed == rhs.speed
    }
}
