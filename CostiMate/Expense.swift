//
//  Expense.swift
//  CostiMate
//
//  Created by Max Huang on 12/02/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import Foundation

enum ExpenseFrequency: String {
    case day
    case week
    case fortnight
    case month
    case year
}

class Expense {
    
    var details: String
    var amount: String
    var frequency: String
    
    init(_ details: String, _ amount: String, _ frequency: ExpenseFrequency) {
        self.details = details
        self.amount = amount
        self.frequency = " / " + frequency.rawValue
    }
    
}
