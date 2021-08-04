//
//  CovidStatusViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift


import UIKit
import SwiftyJSON
import RealmSwift

class CovidStatusViewController: BaseTableViewController {

    private var country: String = ""
    private var stats: Results<StatsCountryItem> = RealmService.getStatsOfCountry()
    private var token: NotificationToken?
    private let countryService = CountryService()
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
        }
    
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            stats = RealmService.getStatsOfCountry()
            let countryObject = try! Realm().object(ofType: CountryItem.self, forPrimaryKey: country)
            token = countryObject?
                .observe(on: .main) { [weak self] change in
                    switch change {
                    case .change(_, let properties):
                        for property in properties {
                            if property.name == "countryStats" {
                                self?.country = property.newValue as? CountryService
                                self?.tableView.reloadData()
                            }
                        }
    
                    case .deleted:
                        self?.navigationController?.popViewController(animated: true)
    
                    case .error(let error):
                        print(error.localizedDescription)
                    }
                }
    
            getStatsOfCountry(country: country) { [weak self] stats in
                guard let self = self, let stats = stats else { return }
                RealmService.saveStatsOfCountry(stats, to: self.coutry)
            }
    
        }
    
}







//class CovidStatusViewController: BaseTableViewController {
//
//    private var country: String = ""
//    private var token: NotificationToken?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//
//    func configure(country: String) {
//        self.country = country
//    }
//
//}



//    private var city: String = ""
//    private var weather: WeatherData?
//    private var token: NotificationToken?
//    private var forecastToken: NotificationToken?
//    private var forecast: List<WeatherData>?
//    private let weatherService = WeatherService()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        weather = RealmService.getWeathers(for: city)
//        forecast = RealmService.getForecast(for: city)
//        let cityObject = try! Realm().object(ofType: CityItem.self, forPrimaryKey: city)
//        token = cityObject?
//            .observe(on: .main) { [weak self] change in
//                switch change {
//                case .change(_, let properties):
//                    for property in properties {
//                        if property.name == "currentWeather" {
//                            self?.weather = property.newValue as? WeatherData
//                            self?.tableView.reloadData()
//                        }
//                    }
//
//                case .deleted:
//                    self?.navigationController?.popViewController(animated: true)
//
//                case .error(let error):
//                    print(error.localizedDescription)
//                }
//            }
//
//        forecastToken = forecast?.observe(on: .main, { [weak self] changes in
//            self?.tableView.reloadData()
//        })
//
//        getWeather(city: city) { [weak self] weather in
//            guard let self = self, let weather = weather else { return }
//            RealmService.saveWeather(weather, to: self.city)
//        }
//
//        getForecast(city: city) { [weak self] forecast in
//            guard let self = self, let forecast = forecast else { return }
//            RealmService.saveForecast(forecast, to: self.city)
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        token?.invalidate()
//    }
//
//    func configure(city: String) {
//        self.city = city
//    }
//
//    enum WeatherParsingError: Error {
//        case invalidURL
//    }
//
//    func getWeather(city: String, completion: @escaping (WeatherData?) -> Void) {
//        weatherService.getWeather(city: city) { [weak self] result in
//           switch result {
//           case .success(let weather):
//               completion(weather)
//
//           case .failure(let error):
//                completion(nil)
//               self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
//           }
//       }
//    }
//
//    func getForecast(city: String, completion: @escaping ([WeatherData]?) -> Void) {
//        let cityObject = try! Realm().object(ofType: CityItem.self, forPrimaryKey: city)
//        weatherService.getWeekForecast(lat: cityObject?.lat ?? 0, lng: cityObject?.lng ?? 0) { [weak self] result in
//           switch result {
//           case .success(let forecast):
//                completion(forecast)
//           case .failure(let error):
//                completion(nil)
//               self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
//           }
//       }
//    }
//
//}
//
//extension WeatherViewController {
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if weather == nil {
//            return 0
//        } else {
//            return 4
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let weather = weather else { return UITableViewCell() }
//
//        if indexPath.section == 0 {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: WeatherResultViewCell.cellIdentifier, for: indexPath) as? WeatherResultViewCell {
//                switch indexPath.row {
//                case 0:
//                    cell.configure(title: "Температура: \(weather.temp) ºC")
//
//                case 1:
//                    cell.configure(title: "Давление: \(weather.pressure)")
//
//                case 2:
//                    cell.configure(title: "Влажность: \(weather.humidity)")
//
//                case 3:
//                    cell.configure(title: "Страна: \(weather.country)")
//
//                default:
//                    break
//                }
//                return cell
//            }
//        }
//
//        fatalError("Couldn't find cell's class")
//    }
//}
