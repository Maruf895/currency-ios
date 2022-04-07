//
//  DetailViewModel+CoreData.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation
import CoreData

extension DetailViewModel {
    
    func getCoreData(_ date: Date = Date()) {
        let context = AppDelegate.getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "\(CurrencySearched.self)")
        request.returnsObjectsAsFaults = false
        
        request.predicate = getDatePredicate(date)
        do {
            guard let currencySearched = try context.fetch(request) as? [CurrencySearched] else { return }
            
            if currencySearched.isEmpty {
                savedCurrencies.accept([DetailModel(true)])
            } else {
                getCurrencyDetails(currencies: currencySearched, date: date)
            }
        } catch {
            savedCurrencies.accept([DetailModel(true)])
        }
    }
    
    private func getDatePredicate(_ date: Date) -> NSPredicate {
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        
        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date)
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)!
        
        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "date >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "date < %@",  dateTo as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            fromPredicate, toPredicate
        ])
        
        return datePredicate
    }
}
