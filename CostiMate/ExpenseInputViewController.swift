//
//  ExpenseInputViewController.swift
//  CostiMate
//
//  Created by Max Huang on 17/02/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import UIKit

class ExpenseInputViewController: UIViewController {

    @IBOutlet weak var expenseErrorLabel: UILabel!
    @IBOutlet weak var amountErrorLabel: UILabel!
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        expenseTextField.delegate = self
        amountTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Force the first responder to resign.
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    
}

extension ExpenseInputViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.expenseTextField {
            self.amountTextField.becomeFirstResponder()
        } else {
            endEditing()
        }
        return true
    }
}
