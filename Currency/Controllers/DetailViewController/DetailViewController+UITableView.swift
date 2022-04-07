//
//  DetailViewController+UITableView.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

extension DetailViewController {
    
    func bindTableViewData() {
        viewModel.savedCurrencies.asObservable().bind(
            to: tableView.rx.items
        ) { (tableView, row, item) -> UITableViewCell in
            if (item.isNoDataFound ?? false) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
                cell.textLabel?.text = StaticLabel.noDataFound
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "\(DetailTableViewCell.self)", for: IndexPath(row: row, section: 0)) as! DetailTableViewCell
                let fromCurrency = item.fromCurrency ?? ""
                let toCurrency = item.toCurrency ?? ""
                let rate = String(format: "%.2f", item.rate ?? 0.0)
                cell.currencyLabel.text = "\(fromCurrency) - \(toCurrency)  --  \(rate)"
                
                return cell
            }
        }.disposed(by: disposeBag)
        viewModel.getCoreData()
    }
}
