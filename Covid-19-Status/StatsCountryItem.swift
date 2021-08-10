//
//  StatsItem.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 04.08.2021.
//

import Foundation
import RealmSwift

class StatsCountryItem: Object {

    @objc dynamic var confirmed: String = ""
    @objc dynamic var deaths: String = ""
    @objc dynamic var recovered: String = ""
    @objc dynamic var countryData: StatsCountryItem?
    @objc dynamic var country: String = ""
    
    override class func primaryKey() -> String? {
        return "country"
    }
    
    convenience init(
        confirmed: String,
        deaths: String,
        recovered: String,
        country: String
    )
    {
        self.init()
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
        self.country = country
    }
    
}
