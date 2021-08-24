//
//  ImageCountryService.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 20.08.2021.
//

import Foundation
import SwiftyJSON

class ImageCountryService {
    
    private let imageCountryService = ImageCountryService()
    
    enum Spec {
        static let scheme = "https"
        static let host = "api.unsplash.com"
    }
    
    enum Endpoint {
        case allCountries
        case statsOfCountry(String)
    }
    
    // https://api.unsplash.com/search/photos?page=1&query=Russia&client_id=XuN1jrhpr9tBExk-eYqYmCV8zwpkpmA2r0GHayi5W58
}
