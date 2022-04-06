//
//  CurrencyViewController+UIInteractor.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

extension CurrencyViewController {
    
    enum CurrencyUIAction {
        case from, to, swap, detail
    }
    
    func handleUIActions(_ action: CurrencyUIAction) {
        switch action {
        case .from: handleFromCurrencyClick()
        case .to: handleToCurrencyClick()
        case .swap: handleSwapCurrencyClick()
        case .detail: handleDetailClick()
        }
    }
    
    private func handleFromCurrencyClick() {
        
    }
    
    private func handleToCurrencyClick() {
        
    }
    
    private func handleSwapCurrencyClick() {
        
    }
    
    private func handleDetailClick() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
