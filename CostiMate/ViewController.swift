//
//  ViewController.swift
//  CostiMate
//
//  Created by Max Huang on 31/01/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import UIKit
import GoogleMobileAds
import PopupDialog
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var expenses: [Expense] = []
    var dbRef: DatabaseReference!


    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = Database.database().reference()
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        expenses = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func createArray() -> [Expense] {
        var tmp = [Expense]()
        
        let exp1 = Expense("Placeholder expense", "$35.00", .week)

        tmp.append(exp1)
        
        return tmp
    }

    
    @IBAction func addButton(_ sender: Any) {
        showCustomDialog()
    }
    
    
    func showCustomDialog(animated: Bool = true) {
        
        // Create a custom view controller
        let expenseInputVC = ExpenseInputViewController(nibName: "ExpenseInputViewController", bundle: nil)
        
        // Create the dialog
        let popup = PopupDialog(viewController: expenseInputVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceUp,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60, action: nil)
        
        
        // Create second button
        let buttonTwo = DefaultButton(title: "ADD EXPENSE", height: 60, dismissOnTap: false) {
            
            if self.validInput(for: expenseInputVC, with: popup) {
                self.setExpense(for: expenseInputVC)
                popup.dismiss(animated: true, completion: nil)
            } else {
                popup.shake()
            }
            
        }

        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
    }
    
    
    func validInput(for vc: ExpenseInputViewController, with popup: PopupDialog) -> Bool {
        if vc.expenseTextField.text == "" {
            vc.errorLabel.text = "Expense field missing"
            return false
        }
        if vc.amountTextField.text == "" {
            vc.errorLabel.text = "Amount field missing"
            return false
        }
        return true
    }
    
    func setExpense(for vc: ExpenseInputViewController) {
        let expense = vc.expenseTextField.text!
        let amount = vc.amountTextField.text!
        let freq = vc.getPickerData()
        
        self.expenses.append(Expense(expense, amount, freq))
        self.tableView .reloadData()
        self.addExpense(expense, amount, freq.rawValue)
    }
    
    
    func addExpense(_ expense: String, _ amount: String, _ freq: String) {
        self.dbRef
            .child("users")
            .child("user1")
            .child("expenses")
            .child("exp2")
            .setValue(["exp":expense, "cost":amount, "freq":freq])
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = expenses[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell") as! ExpenseCell
        
        cell.setExpense(expense: expense)
        
        return cell
    }
}
