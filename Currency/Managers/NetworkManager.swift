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
    
    func callWebService(_ urlEndPoint: EndPoint, parameters: [String: String]? = nil, _ completion: @escaping (Result<Data, Error>) -> ()) {
        let urlRequest = getURLRequest(urlEndPoint, parameters: parameters)
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            if let success = json?["success"] as? Bool, !success {
                completion(.failure(NSError(domain: "Server Error", code: 0)))
            } else {
                completion(.success(data))
            }
        }.resume()
    }
    
    private func getURLRequest(_ urlEndPoint: EndPoint, parameters: [String: String]? = nil) -> URLRequest {
        var components = URLComponents(string: urlEndPoint.url)!
        if let params = parameters {
            components.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.queryItems?.append(URLQueryItem(name: "access_key", value: AppConfiguration.apiKey))
        } else {
            components.queryItems = [URLQueryItem(name: "access_key", value: AppConfiguration.apiKey)]
        }
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        return URLRequest(url: components.url!)
    }
}
