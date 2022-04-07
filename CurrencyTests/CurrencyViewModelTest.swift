//
//  CurrencyViewModelTest.swift
//  CurrencyTests
//
//  Created by Mohd Maruf on 07/04/22.
//

import XCTest
@testable import Currency

class CurrencyViewModelTest: XCTestCase {
    
    func testGetCurrency() {
        let model = CurrenyViewModel()
        
        XCTAssertTrue(model.currencyModel.symbolsList.isEmpty)
        let expactions = expectation(description: "Fetching Daata")
        model.getCurrency { errorMessage in
            XCTAssertTrue(errorMessage.isEmpty)
            expactions.fulfill()
        }
        wait(for: [expactions], timeout: 3)
        XCTAssertFalse(model.currencyModel.symbolsList.isEmpty)
    }
    
    func testGetConvertedCurrencyWithError() {
        let model = CurrenyViewModel()
        
        XCTAssertNil(model.convertedCurrencyRate)
        XCTAssertTrue(model.currencyConvertModel.rates.isEmpty)
        let expactions = expectation(description: "Fetching Daata")
        model.getConvertedCurrency { errorMessage in
            XCTAssertFalse(errorMessage.isEmpty)
            expactions.fulfill()
        }
        wait(for: [expactions], timeout: 3)
        XCTAssertNil(model.convertedCurrencyRate)
        XCTAssertTrue(model.currencyConvertModel.rates.isEmpty)
    }
    
    func testGetConvertedCurrencyWithSuccess() {
        let model = CurrenyViewModel()
        XCTAssertNil(model.convertedCurrencyRate)
        XCTAssertTrue(model.currencyConvertModel.rates.isEmpty)

        model.currencyModel.fromCurrency = "EUR"
        model.currencyModel.toCurrency = "INR"
        let expactions = expectation(description: "Fetching Daata")
        model.getConvertedCurrency { errorMessage in
            XCTAssertTrue(errorMessage.isEmpty)
            expactions.fulfill()
        }
        wait(for: [expactions], timeout: 3)
        XCTAssertNotNil(model.convertedCurrencyRate)
        XCTAssertFalse(model.currencyConvertModel.rates.isEmpty)
    }
    
    func testSwapCurrencies() {
        let model = CurrenyViewModel()
        
        XCTAssertNil(model.currencyModel.fromCurrency)
        XCTAssertNil(model.currencyModel.toCurrency)
        
        model.convertedCurrencyRate = 1.0
        model.swapCurrencies()
        
        XCTAssertNil(model.currencyModel.fromCurrency)
        XCTAssertNil(model.currencyModel.toCurrency)

        model.currencyModel.fromCurrency = "EUR"
        model.currencyModel.toCurrency = "INR"
        
        XCTAssertEqual(model.currencyModel.fromCurrency, "EUR")
        XCTAssertEqual(model.currencyModel.toCurrency, "INR")
        model.swapCurrencies()
        
        XCTAssertEqual(model.currencyModel.fromCurrency, "INR")
        XCTAssertEqual(model.currencyModel.toCurrency, "EUR")
    }
}
