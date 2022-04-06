//
//  CurrencyModel.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

struct CurrencyModel {
    
    let symbolsList: [String]
    var fromCurrency: String? = nil
    var toCurrency: String? = nil
    
    init() {
        symbolsList = []
    }
    
    init(_ json: [String: Any]) {
        let symbols = json["symbols"] as? [String: Any] ?? [:]
        symbolsList = symbols.map { $0.key }.sorted()
    }
}
