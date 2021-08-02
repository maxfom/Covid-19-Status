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
    
    override class func primaryKey() -> String? {
        return "country"
    }
    
    convenience init(country: String, slug: String, is02: String) {
        self.init()
        self.country = country
        self.slug = slug
        self.is02 = is02
    }
    
}

