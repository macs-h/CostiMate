//
//  ViewController.swift
//  CostiMate
//
//  Created by Max Huang on 31/01/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import UIKit
import GoogleMobileAds
//import FirebaseDatabase
import PopupDialog

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bannerView: GADBannerView!
    
    var expenses: [Expense] = []
//    var dbRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        dbRef = Database.database().reference()
        
//        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        
        expenses = createArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createArray() -> [Expense] {
        var tmp = [Expense]()
        
        let exp1 = Expense(details: "exp1")
        let exp2 = Expense(details: "exp2")
        let exp3 = Expense(details: "exp3")
        
        tmp.append(exp1)
        tmp.append(exp2)
        tmp.append(exp3)
        
        return tmp
    }

    @IBAction func addButton(_ sender: Any) {
        showCustomDialog()
    }
    
    func showCustomDialog(animated: Bool = true) {
        // Create a custom view controller
//        let ratingVC = RatingViewController(nibName: "RatingViewController", bundle: nil)
        let ratingVC = ExpenseInputViewController(nibName: "ExpenseInputViewController", bundle: nil)
        // Create the dialog
        let popup = PopupDialog(viewController: ratingVC,
                                buttonAlignment: .horizontal,
                                transitionStyle: .bounceDown,
                                tapGestureDismissal: true,
                                panGestureDismissal: false)
        
        // Create first button
        let buttonOne = CancelButton(title: "CANCEL", height: 60) {
//            self.label.text = "You canceled the rating dialog"
        }
        
        // Create second button
        let buttonTwo = DefaultButton(title: "RATE", height: 60) {
//            self.label.text = "You rated \(ratingVC.cosmosStarRating.rating) stars"
        }
        
        // Add buttons to dialog
        popup.addButtons([buttonOne, buttonTwo])
        
        // Present dialog
        present(popup, animated: animated, completion: nil)
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
