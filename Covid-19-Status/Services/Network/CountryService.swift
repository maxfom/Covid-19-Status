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
        static let host = "api.covid19api.com"
        static let periodFrom = "2020-03-01T00:00:00Z"
        static let periodTo = "2020-04-01T00:00:00Z"
    }
    
    enum Endpoint {
        case allCountries
        case statsOfCountry(String)
        
        var endpointString: String {
            switch self {
            case .allCountries:
                return "/countries"
                
            case .statsOfCountry(let country):
                return "/country/\(country)"
            }
        }
    }
    
    
    func defaultParameters() -> [String: String] {
        [
            "from": Spec.periodFrom,
            "to": Spec.periodTo
        ]
    }
    
    // https://api.covid19api.com/country/south-africa?from=2020-03-01T00:00:00Z&to=2020-04-01T00:00:00Z
    
    
    
    
    @discardableResult
    func sendRequest(endpoint: Endpoint, completion: @escaping (Result<JSON, Error>) -> Void) -> URLSessionDataTask? {
        var components = URLComponents()
        components.scheme = Spec.scheme
        components.host = Spec.host
        components.path = endpoint.endpointString
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
    func sendRequestForCountryStats(endpoint: Endpoint, parameters: [String: String], completion: @escaping (Result<JSON, Error>) -> Void) -> URLSessionDataTask? {
        var components = URLComponents()
        components.scheme = Spec.scheme
        components.host = Spec.host
        components.path = endpoint.endpointString
        let parametersDict = defaultParameters().merging(parameters) { (_, new) in new }
        components.queryItems = parametersDict.map { key, value in
            URLQueryItem(name: key, value: value)
        }
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
    func getCountries(completion: @escaping (Result<[CountryItem], Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequest(endpoint: .allCountries) { result in
            switch result {
            case .success(let json):
                do {
                    let countries = try CountryParser().parseCountries(json: json)
                    completion(.success(countries))
                } catch {
                    completion(.failure(error))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    @discardableResult
    func getStatsOfCountry(country: String, completion: @escaping (Result<[StatsCountryItem], Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequestForCountryStats(
            endpoint: .statsOfCountry(country),
            parameters: [
                "from": Spec.periodFrom,
                "to": Spec.periodTo,
            ]
        ) { result in
            switch result {
            case .success(let json):
                do {
                    let stats = try CountryParser().parseStatsForCurrentCountry(json: json)
                    completion(.success(stats))
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
