//
//  DetailModel.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation

struct DetailModel {
    
    let fromCurrency: String?
    let toCurrency: String?
    let date: Date?
    let rate: Double?
    let isNoDataFound: Bool?
    
    init(object: CurrencySearched, value: Double) {
        fromCurrency = object.fromCurrency
        toCurrency = object.toCurrency
        date = object.date
        rate = value
        isNoDataFound = nil
    }
        
    init(_ noDataFound: Bool) {
        fromCurrency = nil
        toCurrency = nil
        date = nil
        rate = nil
        isNoDataFound = true
    }
    
    init(from: String, to: String, value: Double) {
        fromCurrency = from
        toCurrency = to
        rate = value
        date = nil
        isNoDataFound = nil
    }
}
