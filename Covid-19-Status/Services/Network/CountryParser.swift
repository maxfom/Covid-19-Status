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
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return df
    }()
    
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
    
    func parseImageInfo(json: JSON) throws -> [CountryImageItem] {
        return try json.arrayValue.compactMap { value in
            guard let imageCountry = value["results"]["urls"]["regular"].string,
                  let imageDescription = value["results"]["description"].string
            else {
                throw CountryParsingError.invalidJSON
            }
            return CountryImageItem(
                imageDescription: imageDescription,
                imageCountry: imageCountry
            )
        }
    }
    
    func parseStatsForCurrentCountry(json: JSON) throws -> [StatsCountryItem] {
        return try json.arrayValue.compactMap { value in
            guard let confirmed = value["Confirmed"].int,
                  let deaths = value["Deaths"].int,
                  let recovered = value["Recovered"].int,
                  let country = value["Country"].string,
                  let id = value["ID"].string,
                  let timestamp = value["Date"].string
            else {
                throw CountryParsingError.invalidJSON
            }
            return StatsCountryItem(
                id: id,
                confirmed: confirmed,
                deaths: deaths,
                recovered: recovered,
                country: country,
                date: dateFormatter.date(from: timestamp) ?? Date()
            )
        }
    }
}
