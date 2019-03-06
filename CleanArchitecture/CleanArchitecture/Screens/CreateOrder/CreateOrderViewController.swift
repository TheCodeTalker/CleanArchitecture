//
//  CreateOrderViewController.swift
//  CleanArchitecture
//
//  Created by Chitaranjan Sahu on 04/03/19.
//  Copyright © 2019 Chitaranjan Sahu. All rights reserved.
//

import UIKit

protocol CreateOrderDisplayLogic: class
{
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel)
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
}
class CreateOrderViewController: UITableViewController, CreateOrderDisplayLogic, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    var interactor: CreateOrderBusinessLogic?
    var router: (NSObjectProtocol & CreateOrderRoutingLogic & CreateOrderDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = CreateOrderInteractor()
        let presenter = CreateOrderPresenter()
        let router = CreateOrderRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showOrderToEdit()
    }
    
   
    
    // MARK: Text fields
    
    @IBOutlet var textFields: [UITextField]!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let index = textFields.index(of: textField) {
            if index < textFields.count - 1 {
                let nextTextField = textFields[index + 1]
                nextTextField.becomeFirstResponder()
            }
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            for textField in textFields {
                if textField.isDescendant(of: cell) {
                    textField.becomeFirstResponder()
                }
            }
        }
    }
    
    // MARK: - Shipping method
    
    @IBOutlet weak var shippingMethodTextField: UITextField!
    @IBOutlet var shippingMethodPicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return interactor?.shippingMethods.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return interactor?.shippingMethods[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        shippingMethodTextField.text = interactor?.shippingMethods[row]
    }
    
    // MARK: - Expiration date
    
    @IBOutlet weak var expirationDateTextField: UITextField!
    @IBOutlet var expirationDatePicker: UIDatePicker!
    
    @IBAction func expirationDatePickerValueChanged(_ sender: Any) {
        let date = expirationDatePicker.date
        let request = CreateOrder.FormatExpirationDate.Request(date: date)
        interactor?.formatExpirationDate(request: request)
    }
    
    func displayExpirationDate(viewModel: CreateOrder.FormatExpirationDate.ViewModel) {
        let date = viewModel.date
        expirationDateTextField.text = date
    }
    
    // MARK: - Create order
    
    // MARK: Contact info
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // MARK: Contact info
        let firstName = firstNameTextField.text!
        let lastName = lastNameTextField.text!
        let phone = phoneTextField.text!
        let email = emailTextField.text!
        
        // MARK: Misc
        var id: String? = nil
        var date = Date()
        var total = NSDecimalNumber.notANumber
        
        if let orderToEdit = interactor?.orderToEdit {
            id = orderToEdit.id
            date = orderToEdit.date
            total = orderToEdit.total
            let request = CreateOrder.UpdateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, id: id, date: date, total: total))
            interactor?.updateOrder(request: request)
        } else {
            let request = CreateOrder.CreateOrder.Request(orderFormFields: CreateOrder.OrderFormFields(firstName: firstName, lastName: lastName, phone: phone, email: email, id: id, date: date, total: total))
            interactor?.createOrder(request: request)
        }
    }
    
    func displayCreatedOrder(viewModel: CreateOrder.CreateOrder.ViewModel)
    {
        if viewModel.order != nil {
            router?.routeToListOrders(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to create order", message: "Please correct your order and submit again.")
        }
    }
    
    // MARK: - Edit order
    
    func showOrderToEdit()
    {
        let request = CreateOrder.EditOrder.Request()
        interactor?.showOrderToEdit(request: request)
    }
    
    func displayOrderToEdit(viewModel: CreateOrder.EditOrder.ViewModel)
    {
        let orderFormFields = viewModel.orderFormFields
        firstNameTextField.text = orderFormFields.firstName
        lastNameTextField.text = orderFormFields.lastName
        phoneTextField.text = orderFormFields.phone
        emailTextField.text = orderFormFields.email
    }
    
    // MARK: - Update order
    
    func displayUpdatedOrder(viewModel: CreateOrder.UpdateOrder.ViewModel)
    {
        if viewModel.order != nil {
            router?.routeToShowOrder(segue: nil)
        } else {
            showOrderFailureAlert(title: "Failed to update order", message: "Please correct your order and submit again.")
        }
    }
    
    // MARK: Error handling
    
    private func showOrderFailureAlert(title: String, message: String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        showDetailViewController(alertController, sender: nil)
    }

   
}
