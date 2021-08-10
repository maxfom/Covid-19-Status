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
            country.isFavorite = false
        }
    }
    
    static func getStatsOfCountry(for country: String) -> StatsCountryItem? {
        let realm = try! Realm()
        guard let country = realm.object(ofType: CountryItem.self, forPrimaryKey: country) else { return nil }
        return country.currentStats
    }
    
    static func saveStatsOfCountry(_ stats: StatsCountryItem, to country: String) {
        let realm = try! Realm()
        guard let country = realm.object(ofType: StatsCountryItem.self, forPrimaryKey: country) else { return }
        try? realm.write {
            country.countryData = stats
        }
    }
    
}
