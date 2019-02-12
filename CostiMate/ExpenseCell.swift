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
    
    func setExpense(expense: Expense) {
        label.text = expense.details
    }
    
}
