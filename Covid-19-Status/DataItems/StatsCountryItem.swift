//
//  StatsItem.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 04.08.2021.
//

import Foundation
import RealmSwift

class StatsCountryItem: Object {

    @objc dynamic var id: String = ""
    @objc dynamic var confirmed: Int = 0
    @objc dynamic var deaths: Int = 0
    @objc dynamic var recovered: Int = 0
    @objc dynamic var country: String = ""
    @objc dynamic var date: Date = Date()
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(
        id: String,
        confirmed: Int,
        deaths: Int,
        recovered: Int,
        country: String,
        date: Date)
    {
        self.init()
        self.id = id
        self.confirmed = confirmed
        self.deaths = deaths
        self.recovered = recovered
        self.country = country
        self.date = date
    }
    
}
