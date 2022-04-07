//
//  DateFormatter.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//
import Foundation

extension Date {
    
    func getDateBeforeYesterday() -> String {
        let date = Calendar.current.date(byAdding: .day, value: -2, to: self)!
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM, yyyy"
        
        return formatter.string(from: date)
    }
    
    func getDateForWebService() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter.string(from: self)
    }
}
