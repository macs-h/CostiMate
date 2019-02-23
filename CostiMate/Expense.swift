//
//  Expense.swift
//  CostiMate
//
//  Created by Max Huang on 12/02/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import Foundation

class Expense {
    
    var expense: String
    var amount: String
    var frequency: String
    
    init(_ expense: String, _ amount: String, _ frequency: String) {
        self.expense = expense
        self.amount = amount
        self.frequency = frequency
    }
    
}
