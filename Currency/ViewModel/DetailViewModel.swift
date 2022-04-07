//
//  DetailViewModel.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

class DetailViewModel {
    
    var savedCurrencies = BehaviorRelay<[DetailModel]>(value: [DetailModel]())
    var otherCurrencies = BehaviorRelay<[DetailModel]>(value: [DetailModel]())
    var baseCurrency: String?
    
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
    
    private func getCurrencyDetails(currencies: [CurrencySearched], date: Date) {
        let fromCurrency = currencies.map { $0.fromCurrency ?? "" }
        let toCurrency = currencies.map { $0.toCurrency ?? "" }
        let allCurrency = Array(Set(fromCurrency + toCurrency))
        let param = [
            "symbols": allCurrency.joined(separator: ",")
        ]
        NetworkManager.shared.callWebServiceWithUrl(
            AppConfiguration.baseUrl + date.getDateForWebService(),
            parameters: param
        ) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    
                    self.handleCurrencyDetail(model: CurrencyConvertModel(json), currencies: currencies)
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.savedCurrencies.accept([DetailModel(true)])
            }
        }
    }
    
    private func handleCurrencyDetail(model: CurrencyConvertModel, currencies: [CurrencySearched]) {
        var dataModel = [DetailModel]()
        for item in currencies {
            let fromRate = model.rates[item.fromCurrency ?? ""] ?? 0.0
            let toRate = model.rates[item.toCurrency ?? ""] ?? 0.0
            let convertedRate = (1 / fromRate) * toRate
            
            dataModel.append(DetailModel(object: item, value: convertedRate))
        }
        
        savedCurrencies.accept(dataModel)
    }
    
    func getOtherCurrenciesWebService() {
        // TODO: taking top 10 currencies static
        let param = [
            "symbols": "USD, EUR, GBP, INR, CHF, KWD, BHD, OMR, JOD, GIP, KYD"
        ]
        NetworkManager.shared.callWebService(
            .latest,
            parameters: param
        ) { [weak self] (result) in
            guard let `self` = self else { return }
            
            switch result {
            case .success(let data):
                if let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] {
                    self.handleOtherCurrencies(CurrencyConvertModel(json))
                }
            case .failure(let error):
                print(error.localizedDescription)
                self.otherCurrencies.accept([DetailModel(true)])
            }
        }
    }
    
    private func handleOtherCurrencies(_ model: CurrencyConvertModel) {
        var dataModel = [DetailModel]()
        let fromRate = model.rates[baseCurrency ?? ""] ?? 0.0
        for item in model.rates {
            let toRate = item.value
            let convertedRate = (1 / fromRate) * toRate
            dataModel.append(DetailModel(from: baseCurrency ?? "", to: item.key, value: convertedRate))
        }
        otherCurrencies.accept(dataModel)
    }
}
