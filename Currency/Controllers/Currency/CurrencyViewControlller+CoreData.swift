//
//  CurrencyViewControlller+CoreData.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation
import UIKit
import CoreData

extension CurrencyViewController {
    
    func saveCurrenciesToCoreData() {
        let context = AppDelegate.getContext()
        if !isCurrenciesAlreadySaved() {
            let currencySearched = NSEntityDescription.insertNewObject(
                forEntityName: "\(CurrencySearched.self)",
                into: context
            ) as! CurrencySearched
            
            currencySearched.fromCurrency = viewModel.currencyModel.fromCurrency
            currencySearched.toCurrency = viewModel.currencyModel.toCurrency
            currencySearched.date = Date()
            
            do {
                try context.save()
            } catch let err {
                alert(message: err.localizedDescription)
            }
        }
    }
    
    func isCurrenciesAlreadySaved() -> Bool {
        let context = AppDelegate.getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(CurrencySearched.self)")
        request.returnsObjectsAsFaults = false
        
        request.predicate = getDatePredicate()
        do {
            let currencySearched = try context.fetch(request) as? [CurrencySearched]
            return !(currencySearched?.isEmpty ?? true)
        } catch let err {
            alert(message: err.localizedDescription)
        }
        return false
    }
        
    private func getDatePredicate() -> NSPredicate {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: Date()) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@",  dateTo as NSDate)
        let fromCurrencyPredicate = NSPredicate(format: "fromCurrency == %@",  viewModel.currencyModel.fromCurrency ?? "")
        let toCurrencyPredicate = NSPredicate(format: "toCurrency == %@",  viewModel.currencyModel.toCurrency ?? "")
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            fromPredicate, toPredicate, fromCurrencyPredicate, toCurrencyPredicate
        ])
        
        return datePredicate
    }
}
