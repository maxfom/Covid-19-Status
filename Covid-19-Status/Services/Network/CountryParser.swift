//
//  CountryParser.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 02.08.2021.
//

import Foundation
import SwiftyJSON
import RealmSwift

enum CountryParsingError: Error {
    case invalidURL
    case invalidJSON
}

class CountryParser {
    
    func parseCountries(json: JSON) throws -> [CountryItem] {
        let favoriteSlugs = RealmService.getFavoriteCountries().map { $0.slug }
        return try json.arrayValue.compactMap { value in
            guard let country = value["Country"].string,
                  let slug = value["Slug"].string,
                  let is02 = value["ISO2"].string
            else {
                throw CountryParsingError.invalidJSON
            }
            return CountryItem(
                country: country,
                slug: slug,
                is02: is02,
                isFavorite: favoriteSlugs.contains(slug)
            )
        }
    }
    
    
    func parseStatsForCurrentCountry(json: JSON, country: String) throws -> StatsCountryItem {
        guard let confirmed = json["Confirmed"].string,
                let deaths = json["Deaths"].string,
                let recovered = json["Recovered"].string,
                let country = json["Country"].string
        else {
            throw CountryParsingError.invalidJSON
        }
        return StatsCountryItem(
            confirmed: confirmed,
            deaths: deaths,
            recovered: recovered,
            country: country
        )
    }
    
}
