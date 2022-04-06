//
//  CurrenyViewModel.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

class CurrenyViewModel {
    
    var currencyModel = CurrencyModel()
    
    func getCurrency(_ completion: @escaping (_ errorMessage: String) -> ()) {
        NetworkManager.shared.callWebService(.symbols) { (result) in
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
}
