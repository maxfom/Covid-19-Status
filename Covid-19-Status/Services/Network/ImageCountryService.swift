//
//  ImageCountryService.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 20.08.2021.
//

import Foundation
import SwiftyJSON

class ImageCountryService {
    
    private let networkService = NetworkService()
    private let countryParser = CountryParser()
    
    enum Spec {
        static let scheme = "https"
        static let host = "api.unsplash.com"
        static let appId = "6uyiWMPwEKa7ylJEjZXjy9znIhik2LUeaf7uQlJvBOc"
        //static let country = "Russia"
        static let per_page = "1"
    }
    
    enum ImageCountryParsingError: Error {
        case invalidURL
        case invalidJSON
    }
    
    enum Endpoint {
        case statsOfCountry
        
        var endpointString: String {
            switch self {
            case .statsOfCountry:
                return "/search/photos"
            }
        }
    }
    
    func defaultParameters() -> [String: String] {
        [
            "client_id": Spec.appId,
            //"query": Spec.country,
            "per_page": Spec.per_page
        ]
    }
    
    // https://api.unsplash.com/search/photos?page=1&query=Russia&client_id=XuN1jrhpr9tBExk-eYqYmCV8zwpkpmA2r0GHayi5W58
    
    

    @discardableResult
    func sendRequest(endpoint: Endpoint, parameters: [String: String], completion: @escaping (Result<JSON, Error>) -> Void) -> URLSessionDataTask? {
        var components = URLComponents()
        components.scheme = Spec.scheme
        components.host = Spec.host
        components.path = endpoint.endpointString
        let parametersDict = defaultParameters().merging(parameters) { (_, new) in new }
        components.queryItems = parametersDict.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        guard let url = components.url else {
            completion(.failure(ImageCountryParsingError.invalidURL))
            return nil
        }
        let request = URLRequest(url: url)
        let task = networkService.sendRequest(request: request, completion: completion)
        task.resume()
        return task
}
    @discardableResult
    func getImageCountry(country: String, completion: @escaping (Result<CountryImageItem, Error>) -> Void) -> URLSessionDataTask? {
        let task = sendRequest(
            endpoint: .statsOfCountry,
            parameters: ["query" : country]
        ) { result in
            switch result {
            case .success(let json):
                do {
                    let countryInfo = try CountryParser().parseImageInfo(json: json)
                    completion(.success(countryInfo))
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
