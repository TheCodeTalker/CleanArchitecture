//
//  ShowOrderRouter.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 05/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import UIKit

@objc protocol ShowOrderRoutingLogic
{
    func routeToEditOrder(segue: UIStoryboardSegue?)
}

protocol ShowOrderDataPassing
{
    var dataStore: ShowOrderDataStore? { get }
}

class ShowOrderRouter: NSObject, ShowOrderRoutingLogic, ShowOrderDataPassing
{
    weak var viewController: ShowOrderViewController?
    var dataStore: ShowOrderDataStore?
    
    // MARK: Routing
    
    func routeToEditOrder(segue: UIStoryboardSegue?)
    {
        if let segue = segue {
            let destinationVC = segue.destination as! CreateOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditOrder(source: dataStore!, destination: &destinationDS)
        } else {
            let destinationVC = viewController?.storyboard?.instantiateViewController(withIdentifier: "CreateOrderViewController") as! CreateOrderViewController
            var destinationDS = destinationVC.router!.dataStore!
            passDataToEditOrder(source: dataStore!, destination: &destinationDS)
            navigateToEditOrder(source: viewController!, destination: destinationVC)
        }
    }
    
    // MARK: Navigation
    
    func navigateToEditOrder(source: ShowOrderViewController, destination: CreateOrderViewController)
    {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToEditOrder(source: ShowOrderDataStore, destination: inout CreateOrderDataStore)
    {
        destination.orderToEdit = source.order
    }
}
