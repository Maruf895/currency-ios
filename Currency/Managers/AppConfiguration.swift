//
//  AppConfiguration.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

class AppConfiguration {
    
    private init() { }
    
    static let apiKey = Bundle.main.infoDictionary?["ApiKey"] as? String ?? ""
    static let baseUrl = (Bundle.main.infoDictionary?["BaseUrl"] as? String ?? "").replacingOccurrences(of: "\\", with: "")
}
