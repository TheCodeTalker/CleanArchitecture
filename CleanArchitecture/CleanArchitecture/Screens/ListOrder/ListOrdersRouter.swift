//
//  ListOrdersRouter.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 04/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import UIKit

@objc protocol ListOrdersRoutingLogic {
    func routeToCreateOrder(segue: UIStoryboardSegue?)
    func routeToShowOrder(segue: UIStoryboardSegue?)
}

protocol ListOrdersDataPassing {
    var dataStore: ListOrdersDataStore? { get }
}

class ListOrdersRouter: NSObject, ListOrdersRoutingLogic, ListOrdersDataPassing{
    weak var viewController: ListViewController?
    var dataStore: ListOrdersDataStore?
    
    
    func routeToCreateOrder(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! CreateOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCreateOrder(source: dataStore!, destination: &destinationDS)
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "CreateOrderViewController") as! CreateOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToCreateOrder(source: dataStore!, destination: &destinationDS)
            navigateToCreateOrder(source: viewController!, destination: destinationVC)
        }
    }
    
    func routeToShowOrder(segue: UIStoryboardSegue?) {
        if let segue = segue {
            let destinationVC = segue.destination as! ShowOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowOrder(source: dataStore!, destination: &destinationDS)
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "ShowOrderViewController") as! ShowOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToShowOrder(source: dataStore!, destination: &destinationDS)
            navigateToShowOrder(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToCreateOrder(source: ListViewController, destination: CreateOrderViewController) {
        source.show(destination, sender: nil)
    }
    
    func navigateToShowOrder(source: ListViewController, destination: ShowOrderViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToCreateOrder(source: ListOrdersDataStore, destination: inout CreateOrderDataStore)
    {
    }

    func passDataToShowOrder(source: ListOrdersDataStore, destination: inout ShowOrderDataStore)
    {
        let selectedRow = viewController?.tableView.indexPathForSelectedRow?.row
        destination.order = source.orders?[selectedRow!]
    }
    
    
}
