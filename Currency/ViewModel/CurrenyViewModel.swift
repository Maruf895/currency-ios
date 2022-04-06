//
//  CurrenyViewModel.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

class CurrenyViewModel {
    
    var currencyModel = CurrencyModel()
    var currencyConvertModel = CurrencyConvertModel()
    var convertedCurrencyRate: Double?
    
    func getCurrency(_ completion: @escaping (_ errorMessage: String) -> ()) {
        NetworkManager.shared.callWebService(.symbols) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let data):
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                self.currencyModel = CurrencyModel(json ?? [:])
                completion("")
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func getConvertedCurrency(_ completion: @escaping (_ errorMessage: String) -> ()) {
        let param = [
            "symbols": "\(currencyModel.fromCurrency ?? ""),\(currencyModel.toCurrency ?? "")"
        ]
        NetworkManager.shared.callWebService(.latest, parameters: param) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let data):
                self.handleCurrencyConvertResponse(data: data, completion)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func handleCurrencyConvertResponse(data: Data, _ completion: @escaping (_ errorMessage: String) -> ()) {
        let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        currencyConvertModel = CurrencyConvertModel(json ?? [:])
        let fromRate = currencyConvertModel.rates[currencyModel.fromCurrency ?? ""] ?? 0.0
        let toRate = currencyConvertModel.rates[currencyModel.toCurrency ?? ""] ?? 0.0
        convertedCurrencyRate = (1 / fromRate) * toRate

        completion("")
    }
    
    func swapCurrencies() {
        let swapCurrency = currencyModel.fromCurrency
        currencyModel.fromCurrency = currencyModel.toCurrency
        currencyModel.toCurrency = swapCurrency

        if convertedCurrencyRate != nil {
            let fromRate = currencyConvertModel.rates[currencyModel.fromCurrency ?? ""] ?? 0.0
            let toRate = currencyConvertModel.rates[currencyModel.toCurrency ?? ""] ?? 0.0
            convertedCurrencyRate = (1 / fromRate) * toRate
        }
    }
}
