//
//  CreateOrderRouter.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import Foundation
import UIKit
@objc protocol CreateOrderRoutingLogic {
    func routeToListOrders(segue: UIStoryboardSegue?)
    func routeToShowOrder(segue: UIStoryboardSegue?)
}

protocol CreateOrderDataPassing {
    var dataStore: CreateOrderDataStore? { get }
}

class CreateOrderRouter: NSObject, CreateOrderRoutingLogic, CreateOrderDataPassing {
    weak var viewController: CreateOrderViewController?
    var dataStore: CreateOrderDataStore?
    
    // MARK: Routing
    
    func routeToListOrders(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToListOrders(source: dataStore!, destination: &destinationDS)
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            let destinationVC = viewController?.navigationController?.viewControllers[index] as! ListViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToListOrders(source: dataStore!, destination: &destinationDS)
            navigateToListOrders(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowOrder(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowOrder(source: dataStore!, destination: &destinationDS)
        } else {
            let index = viewController!.navigationController!.viewControllers.count - 2
            let destinationVC = viewController?.navigationController?.viewControllers[index] as! ShowOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowOrder(source: dataStore!, destination: &destinationDS)
            navigateToShowOrder(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToListOrders(source: CreateOrderViewController, destination: ListViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    func navigateToShowOrder(source: CreateOrderViewController, destination: ShowOrderViewController) {
        source.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Passing data
    
    func passDataToListOrders(source: CreateOrderDataStore, destination: inout ListOrdersDataStore) {
    }
    
    func passDataToShowOrder(source: CreateOrderDataStore, destination: inout ShowOrderDataStore) {
        destination.order = source.orderToEdit
    }
}
