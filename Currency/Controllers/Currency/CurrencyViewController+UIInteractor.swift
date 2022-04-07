//
//  CurrencyViewController+UIInteractor.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

extension CurrencyViewController {
    
    enum CurrencyUIAction {
        case from, to, swap, detail
    }
    
    func handleUIActions(_ action: CurrencyUIAction) {
        switch action {
        case .from: handleFromCurrencyClick()
        case .to: handleToCurrencyClick()
        case .swap: handleSwapCurrencyClick()
        case .detail: handleDetailClick()
        }
    }
    
    private func handleFromCurrencyClick() {
        var currencyList = viewModel.currencyModel.symbolsList
        if let toCurrency = viewModel.currencyModel.toCurrency {
            currencyList = viewModel.currencyModel.symbolsList.filter { $0 != toCurrency }
        }
        openPickerView(isFrom: true, currencyList: currencyList)
    }
    
    private func handleToCurrencyClick() {
        var currencyList = viewModel.currencyModel.symbolsList
        if let fromCurrency = viewModel.currencyModel.fromCurrency {
            currencyList = viewModel.currencyModel.symbolsList.filter { $0 != fromCurrency }
        }
        openPickerView(isFrom: false, currencyList: currencyList)
    }
    
    private func handleSwapCurrencyClick() {
        viewModel.swapCurrencies()
        updateUIWithConvertedCurrency()
        
        let swapButtonTitle = fromCurrencyButton.titleLabel?.text
        fromCurrencyButton.setTitle(toCurrencyButton.titleLabel?.text, for: .normal)
        toCurrencyButton.setTitle(swapButtonTitle, for: .normal)
    }
    
    private func handleDetailClick() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        if fromCurrencyButton.titleLabel?.text != ButtonTitle.from {
            controller.viewModel.baseCurrency = fromCurrencyButton.titleLabel?.text
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func openPickerView(isFrom: Bool, currencyList: [String]) {
        guard !viewModel.currencyModel.symbolsList.isEmpty else {
            alert(message: Alerts.currencyNotFound)
            return
        }
        let selectedValue = isFrom ? viewModel.currencyModel.fromCurrency : viewModel.currencyModel.toCurrency
        PickerView.shared.showPicker(currencyList, selectedValue: selectedValue) { [weak self] value in
            guard let self = self, let selectedCurrency = value as? String else { return }
            
            self.handlePickerSelection(isFrom: isFrom, selectedCurrency: selectedCurrency)
        }
    }
    
    private func handlePickerSelection(isFrom: Bool, selectedCurrency: String) {
        if isFrom {
            viewModel.currencyModel.fromCurrency = selectedCurrency
            fromCurrencyButton.setTitle(selectedCurrency, for: .normal)
        } else {
            viewModel.currencyModel.toCurrency = selectedCurrency
            toCurrencyButton.setTitle(selectedCurrency, for: .normal)
        }
        if viewModel.currencyModel.fromCurrency != nil && viewModel.currencyModel.toCurrency != nil {
            showLoader()
            viewModel.getConvertedCurrency { [weak self] errorMessage in
                guard let `self` = self else { return }
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                    self.updateUIWithConvertedCurrency()
                }
            }
        }
    }
    
    private func updateUIWithConvertedCurrency() {
        if (fromCurrencyTextField.text ?? "").isEmpty {
            fromCurrencyTextField.text = "1"
            
            toCurrencyTextField.text = String(format: "%.2f", viewModel.convertedCurrencyRate ?? 0.0)
        } else {
            let convertedRate = viewModel.convertedCurrencyRate ?? 0.0
            let amount = Double(fromCurrencyTextField.text ?? "") ?? 0.0
            toCurrencyTextField.text = String(format: "%.2f", convertedRate * amount)
        }
    }
}
