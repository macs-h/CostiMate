//
//  ExpenseInputViewController.swift
//  CostiMate
//
//  Created by Max Huang on 17/02/19.
//  Copyright © 2019 The Lucky App Brewery. All rights reserved.
//

import UIKit

class ExpenseInputViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var expenseTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var frequencyPickerView: UIPickerView!
    
    let pickerData: [String] = [ ExpenseFrequency.day.rawValue,
                                 ExpenseFrequency.week.rawValue,
                                 ExpenseFrequency.fortnight.rawValue,
                                 ExpenseFrequency.month.rawValue,
                                 ExpenseFrequency.year.rawValue]
    
    var selectedPickerData: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        expenseTextField.delegate = self
        
        amountTextField.delegate = self
        amountTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        amountTextField.keyboardType = UIKeyboardType.numberPad
        
        frequencyPickerView.delegate = self
        frequencyPickerView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Force the first responder to resign.
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    func getPickerData() -> ExpenseFrequency {
        var freq: ExpenseFrequency = .day
        switch selectedPickerData {
            case "day": freq = .day
            case "week": freq = .week
            case "fortnight": freq = .fortnight
            case "month": freq = .month
            case "year": freq = .year
            default:
                freq = .day
            
        }
        
        return freq
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


extension ExpenseInputViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedPickerData = pickerData[row]
    }
}


extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}
