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
import LoadingPlaceholderView

//class TableContainerView: UIView {

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.coverableCellsIdentifiers = ["ExpenseCell", "ExpenseCell2", "ExpenseCell3"]
        }
    }

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var tableContainer: UIView!
    
    var expenses: [Expense] = []
    var dbRef: DatabaseReference?
//    var dbHandle: DatabaseHandle?
    private var loadingPlaceholderView = LoadingPlaceholderView()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadingPlaceholderView.cover(tableContainer)
        
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dbRef = Database.database().reference()
        populateTable()
        
    }
    
    func populateTable() {
        dbRef?.child("users").child("user1").observeSingleEvent(of: .value, with: { (snapshot) in
            if let dbEntry = snapshot.value as? NSDictionary {
                if let expenseDict = dbEntry["expenses"] as? NSDictionary {
                    
                    for (key, value) in expenseDict {
                        let expense = key as? String ?? ""
                        var amount: String = ""
                        var freq: String = ""
                        
                        for (key, value) in value as! NSDictionary {
                            if key as? String == "amount" {
                                amount = value as? String ?? ""
                            } else if key as? String == "freq" {
                                freq = value as? String ?? ""
                            }
                        }
                        
                        self.expenses.append( Expense(expense, amount, freq) )
                    }
                }
            }
            self.loadingPlaceholderView.uncover()
            self.tableView.reloadData()
        })
    }
    
    
//    func createArray() -> [Expense] {
//        var tmp = [Expense]()
//
////        let exp1 = Expense("Placeholder expense", "$35.00", .week)
////
////        tmp.append(exp1)
//
//        return tmp
//    }
    
    func addToOnlineDB(_ e: Expense) {
        self.dbRef?
            .child("users")
            .child("user1")
            .child("expenses")
            .child(e.expense)
            .setValue(["amount":e.amount, "freq":e.frequency])
    }
    
    func deleteFromOnlineDB(_ e: Expense) {
        self.dbRef?
            .child("users")
            .child("user1")
            .child("expenses")
            .child(e.expense)
            .removeValue()
    }
    
    func addExpense(_ expense: String, _ amount: String, _ freq: String) {
        
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
            
            if self.isValidInput(for: expenseInputVC, with: popup) {
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
    
    
    func isValidInput(for vc: ExpenseInputViewController, with popup: PopupDialog) -> Bool {
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
        
//        self.expenses.append(Expense(expense, amount, freq))
//        self.tableView .reloadData()
        self.addExpense(expense, amount, freq)
    }
    
    
   
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expense = expenses[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseCell") as! ExpenseCell
        
        cell.setExpense(expense)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            // delete item at indexPath
            let itemRemoved = self.expenses.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.deleteFromOnlineDB(itemRemoved)
            print(self.expenses)
        }
        
        return [delete]
        
    }
}
