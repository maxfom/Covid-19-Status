//
//  CountryItem.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import Foundation
import RealmSwift

class CountryItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var lat: Double = 0
    @objc dynamic var lng: Double = 0
    //@objc dynamic var currentWeather: WeatherData?
    //let forecast = List<WeatherData>()
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
    convenience init(title: String, lat: Double, lng: Double) {
        self.init()
        self.title = title
        self.lat = lat
        self.lng = lng
    }
    
}

