//
//  CountryService.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 26.07.2021.
//

import Foundation
import SwiftyJSON

class CountryService {
    
    private let networkService = NetworkService()
    
    private enum Spec {
        static let scheme = "https"
        static let host = "api.covid19api.com"    }
    
    enum Endpoint: String {
        case allCountries = "/countries"
    }
    
    
    @discardableResult
    func sendRequest(endpoint: Endpoint, completion: @escaping (Result<JSON, Error>) -> Void) -> URLSessionDataTask? {
        var components = URLComponents()
        components.scheme = Spec.scheme
        components.host = Spec.host
        components.path = endpoint.rawValue
        guard let url = components.url else {
            completion(.failure(CountryParsingError.invalidURL))
            return nil
        }
        let request = URLRequest(url: url)
        let task = networkService.sendRequest(request: request, completion: completion)
        task.resume()
        return task
    }
    
    @discardableResult
    func getCountry(country: String, completion: @escaping (Result<CountryItem, Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequest(endpoint: .allCountries) { result in
            switch result {
            case .success(let json):
                do {
                    let country = try CountryParser().parseCountry(json: json)
                    completion(.success(country))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }

}
