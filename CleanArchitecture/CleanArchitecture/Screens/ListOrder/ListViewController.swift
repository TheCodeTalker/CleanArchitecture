//
//  ListViewController.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 25/02/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import UIKit

protocol ListOrdersDisplayLogic: class
{
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel)
}

class ListViewController: UITableViewController, ListOrdersDisplayLogic {
    
    var displayedOrders: [ListOrders.FetchOrders.ViewModel.DisplayedOrder] = []
    var interactor: ListOrdersBusinessLogic?
    var router: (NSObjectProtocol & ListOrdersRoutingLogic & ListOrdersDataPassing)?
    
    
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
    
    private func setup() {
        let viewController = self
        let interactor = ListOrdersInteractor()
        let presenter = ListOrdersPresenter()
        let router = ListOrdersRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    
    
    // MARK: View lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchOrders()
        funSomthings()
    }
    func funSomthings()  {
        let array = [""]
        guard let value  = array[safe: 5] else {
            print("can't crash the code")
            return
        }
        print("\(value)")
    }
    
    // MARK: - Fetch orders
    
    func fetchOrders() {
        let request = ListOrders.FetchOrders.Request()
        interactor?.fetchOrders(request: request)
    }
    
    
    func displayFetchedOrders(viewModel: ListOrders.FetchOrders.ViewModel) {
        displayedOrders = viewModel.displayedOrders
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: - Tableview data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayedOrders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let displayOrder = displayedOrders[indexPath.row]
       let cell = tableView.dequeueReusableCell(withIdentifier: "OrderTableViewCell", for: indexPath)
        cell.textLabel?.text = displayOrder.date
        cell.detailTextLabel?.text = displayOrder.total
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

public extension Collection where Indices.Iterator.Element == Index{
    public subscript (safe index:Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
