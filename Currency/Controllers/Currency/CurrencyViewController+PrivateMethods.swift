//
//  CurrencyViewController+PrivateMethods.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

extension CurrencyViewController {
    
    func setupInitials() {
        getCurrency()
    }
    
    private func getCurrency() {
        showLoader()
        viewModel.getCurrency { errorMessage in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
                if !errorMessage.isEmpty {
                    self.alert(message: errorMessage)
                }
            }
        }
    }
}
