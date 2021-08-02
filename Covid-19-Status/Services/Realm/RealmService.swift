//
//  RealmService.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    static func saveCountry(country: CountryItem) {
        let realm = try! Realm()
        try? realm.write {
            realm.add(country, update: .all)
        }
    }
    
    static func getCountries() -> Results<CountryItem> {
        let realm = try! Realm()
        return realm.objects(CountryItem.self).sorted(byKeyPath: "country")
    }
    
    static func removeCountry(_ country: CountryItem) {
        let realm = try! Realm()
        try? realm.write {
            realm.delete(country)
        }
    }
    
}
