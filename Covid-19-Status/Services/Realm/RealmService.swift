//
//  RealmService.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import Foundation
import RealmSwift

class RealmService {
    
    static func saveCountries(countries: [CountryItem]) {
        let realm = try! Realm()
        try? realm.write {
            realm.add(countries, update: .modified)
        }
    }
    
    static func getCountries() -> Results<CountryItem> {
        let realm = try! Realm()
        return realm.objects(CountryItem.self).sorted(byKeyPath: "country")
    }
    
    static func removeAllCountries() {
        let realm = try! Realm()
        try? realm.write {
            realm.delete(realm.objects(CountryItem.self))
        }
    }
    
    static func saveImageInfo(countryInfo: [CountryImageItem]) {
        let realm = try! Realm()
        try? realm.write {
            realm.add(countryInfo, update: .modified)
        }
    }
    
    static func getImageInfo() -> Results<CountryImageItem> {
        let realm = try! Realm()
        return realm.objects(CountryImageItem.self)
    }
    
    static func removeImageInfo() {
        let realm = try! Realm()
        try? realm.write {
            realm.delete(realm.objects(CountryImageItem.self))
        }
    }
    
    static func getFavoriteCountries() -> Results<CountryItem> {
        let realm = try! Realm()
        let countries = realm.objects(CountryItem.self).filter("isFavorite == true").sorted(byKeyPath: "country")
        return countries
    }
    
    static func addFavoriteCountry(slug: String) {
        let realm = try! Realm()
        guard let country = realm.object(ofType: CountryItem.self, forPrimaryKey: slug) else { return }
        try? realm.write {
            country.isFavorite = true
        }
    }
    
    static func removeFavoriteCountry(slug: String) {
        let realm = try! Realm()
        guard let country = realm.object(ofType: CountryItem.self, forPrimaryKey: slug) else { return }
        try? realm.write {
            realm.delete(realm.objects(StatsCountryItem.self).filter("country == %@", country.country))
            country.isFavorite = false
        }
    }
        
    static func saveStatsOfCountry(_ stats: [StatsCountryItem], to country: CountryItem) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(realm.objects(StatsCountryItem.self).filter("country == %@", country.country))
            country.currentStats.append(objectsIn: stats)
        }
    }
    
}
