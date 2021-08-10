//
//  CountryItem.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import Foundation
import RealmSwift

class CountryItem: Object {
    
    @objc dynamic var country: String = ""
    @objc dynamic var slug: String = ""
    @objc dynamic var is02: String = ""
    @objc dynamic var isFavorite: Bool = false
    @objc dynamic var currentStats: StatsCountryItem?
    
    override class func primaryKey() -> String? {
        return "slug"
    }
    
    convenience init(country: String, slug: String, is02: String, isFavorite: Bool) {
        self.init()
        self.country = country
        self.slug = slug
        self.is02 = is02
        self.isFavorite = isFavorite
    }
    
}

