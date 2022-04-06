//
//  NetworkManager.swift
//  Currency
//
//  Created by Mohd Maruf on 06/04/22.
//

import Foundation

class NetworkManager {
    
    private init() { }
    
    enum EndPoint: String {
        case symbols = "symbols"
        case latest = "latest"
        
        var url: String {
            return "\(AppConfiguration.baseUrl)\(self.rawValue)"
        }
    }
    
    static let shared = NetworkManager()
    
    func callWebService(_ urlEndPoint: EndPoint, _ completion: @escaping (Result<Data, Error>) -> ()) {
        let finalUrl = "\(urlEndPoint.url)?access_key=\(AppConfiguration.apiKey)"
        debugPrint("URL: \(finalUrl)")
        
        guard let url = URL(string: finalUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else { return }
            
            completion(.success(data))
        }.resume()
    }
}
