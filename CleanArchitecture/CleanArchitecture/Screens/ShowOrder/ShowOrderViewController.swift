//
//  ShowOrderViewController.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 04/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//
import UIKit

protocol ShowOrderDisplayLogic: class
{
    func displayOrder(viewModel: ShowOrder.GetOrder.ViewModel)
}

class ShowOrderViewController: UIViewController, ShowOrderDisplayLogic
{
    var interactor: ShowOrderBusinessLogic?
    var router: (NSObjectProtocol & ShowOrderRoutingLogic & ShowOrderDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        let viewController = self
        let interactor = ShowOrderInteractor()
        let presenter = ShowOrderPresenter()
        let router = ShowOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        getOrder()
    }
    
    // MARK: - Get order
    
    @IBOutlet weak var orderIDLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderEmailLabel: UILabel!
    @IBOutlet weak var orderNameLabel: UILabel!
    @IBOutlet weak var orderTotalLabel: UILabel!
    
    func getOrder()
    {
        let request = ShowOrder.GetOrder.Request()
        interactor?.getOrder(request: request)
    }
    
    func displayOrder(viewModel: ShowOrder.GetOrder.ViewModel)
    {
        let displayedOrder = viewModel.displayedOrder
        orderIDLabel.text = displayedOrder.id
        orderDateLabel.text = displayedOrder.date
        orderEmailLabel.text = displayedOrder.email
        orderNameLabel.text = displayedOrder.name
        orderTotalLabel.text = displayedOrder.total
    }
}
