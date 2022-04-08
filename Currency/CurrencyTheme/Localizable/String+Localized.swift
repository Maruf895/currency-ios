//
//  String+Localized.swift
//  Currency
//
//  Created by Mohd Maruf on 08/04/22.
//

import Foundation

extension String {
    func loadLocalizedString() -> String {
       return NSLocalizedString(self, comment: "")
    }
}
