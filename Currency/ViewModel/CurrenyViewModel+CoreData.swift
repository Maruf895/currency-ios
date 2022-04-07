//
//  CurrencyViewControlller+CoreData.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation
import CoreData

extension CurrenyViewModel {
    
    func saveCurrenciesToCoreData() {
        let context = AppDelegate.getContext()
        if !isCurrenciesAlreadySaved() {
            let currencySearched = NSEntityDescription.insertNewObject(
                forEntityName: "\(CurrencySearched.self)",
                into: context
            ) as! CurrencySearched
            
            currencySearched.fromCurrency = currencyModel.fromCurrency
            currencySearched.toCurrency = currencyModel.toCurrency
            currencySearched.date = Date()
            
            try? context.save()
        }
    }
    
    func isCurrenciesAlreadySaved() -> Bool {
        if currencyModel.fromCurrency == nil || currencyModel.toCurrency == nil {
            return true
        }
        let context = AppDelegate.getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(CurrencySearched.self)")
        request.returnsObjectsAsFaults = false
        
        request.predicate = getDatePredicate()
        do {
            let currencySearched = try context.fetch(request) as? [CurrencySearched]
            return !(currencySearched?.isEmpty ?? true)
        } catch {
            print("Error")
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
        let fromCurrencyPredicate = NSPredicate(format: "fromCurrency == %@",  currencyModel.fromCurrency ?? "")
        let toCurrencyPredicate = NSPredicate(format: "toCurrency == %@",  currencyModel.toCurrency ?? "")
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            fromPredicate, toPredicate, fromCurrencyPredicate, toCurrencyPredicate
        ])
        
        return datePredicate
    }
}
