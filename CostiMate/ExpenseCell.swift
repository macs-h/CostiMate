//
//  ExpenseCell.swift
//  CostiMate
//
//  Created by Max Huang on 12/02/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import UIKit

class ExpenseCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var frequency: UILabel!
    
    func setExpense(expense: Expense) {
        label.text = expense.details
        amount.text = expense.amount
        frequency.text = expense.frequency
    }
    
}
