//
//  DetailViewController+UIInteractor.swift
//  Currency
//
//  Created by Mohd Maruf on 07/04/22.
//

import Foundation

extension DetailViewController {
    
    func showDateSelectionOptions() {
        
        PickerView.shared.showPicker(
            [ButtonTitle.today, ButtonTitle.yesterday, Date().getDateBeforeYesterday()],
            selectedValue: dateButton.titleLabel?.text
        ) { [weak self] selectedValue in
            guard let `self` = self, let value = selectedValue as? String else { return }
            
            self.dateButton.setTitle(value, for: .normal)
            switch value {
            case ButtonTitle.today:
                self.viewModel.getCoreData()
            case ButtonTitle.yesterday:
                if let date = Calendar.current.date(byAdding: .day, value: -1, to: Date()) {
                    self.viewModel.getCoreData(date)
                }
            default:
                if let date = Calendar.current.date(byAdding: .day, value: -2, to: Date()) {
                    self.viewModel.getCoreData(date)
                }
            }
        }
    }
}
