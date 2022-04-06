//
//  CurrencyViewController+UITextField.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation
import UIKit

extension CurrencyViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let convertedCurrency = viewModel.convertedCurrencyRate else { return true }
        
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        guard let value = Double(txtAfterUpdate) else {
            if textField == fromCurrencyTextField {
                toCurrencyTextField.text = ""
            } else {
                fromCurrencyTextField.text =  ""
            }
            return true
        }
        
        if textField == fromCurrencyTextField {
            toCurrencyTextField.text = String(format: "%.2f", convertedCurrency * value)
        } else {
            fromCurrencyTextField.text =  String(format: "%.2f", value / convertedCurrency)
        }
        return true
    }
}
