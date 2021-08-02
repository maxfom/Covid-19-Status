//
//  CountryParser.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 02.08.2021.
//

import Foundation
import SwiftyJSON

enum CountryParsingError: Error {
    case invalidURL
    case invalidJSON
}

class CountryParser {
    
    func parseCountry(json: JSON) throws -> CountryItem {
        guard let country = json["Country"].string,
              let slug = json["Slug"].string,
              let is02 = json["ISO2"].string
        else {
            throw CountryParsingError.invalidJSON
        }
        return CountryItem(
            country: country,
            slug: slug,
            is02: is02
        )
    }
    
}
