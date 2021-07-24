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
        return realm.objects(CountryItem.self).sorted(byKeyPath: "title")
    }
    
    static func removeCountry(_ country: CountryItem) {
        let realm = try! Realm()
        try? realm.write {
            realm.delete(country)
        }
    }
    
//    static func saveWeather(_ weather: WeatherData, to country: String) {
//        let realm = try! Realm()
//        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return }
//        try? realm.write {
//            city.currentWeather = weather
//        }
//    }
//
//    static func getWeathers(for city: String) -> WeatherData? {
//        let realm = try! Realm()
//        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return nil }
//        return city.currentWeather
//    }
//
//    static func saveForecast(_ weathers: [WeatherData], to city: String) {
//        let realm = try! Realm()
//        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return }
//        let oldWeather = city.forecast
//        try? realm.write {
//            realm.delete(oldWeather)
//            city.forecast.append(objectsIn: weathers)
//        }
//    }
//
//    static func getForecast(for city: String) -> List<WeatherData>? {
//        let realm = try! Realm()
//        guard let city = realm.object(ofType: CityItem.self, forPrimaryKey: city) else { return nil }
//        return city.forecast
//    }
    
}
