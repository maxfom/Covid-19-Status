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
    
            func getStatsOfCountry(country: country) { [weak self] stats in
                guard let self = self, let stats = stats else { return }
                RealmService.saveStatsOfCountry(stats, to: self.coutry)
            }
            
            
            func configure(country: String) {
                    self.country = country
    
        }
    
        }

extension CovidStatusViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if stats == nil {
            return 0
        } else {
            return 4
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let stats = stats else { return UITableViewCell() }

        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CovidStatusViewCell.cellIdentifier, for: indexPath) as? CovidStatusViewController {
                switch indexPath.row {
                case 0:
                    cell.configure(title: "Подтверждено: \(stats.confirmed) ºC")

                case 1:
                    cell.configure(title: "Смертей: \(stats.deaths)")

                case 2:
                    cell.configure(title: "Выздоровили: \(stats.recovered)")

                case 3:
                    cell.configure(title: "Страна: \(stats.country)")

                default:
                    break
                }
                return cell
            }
        }

        fatalError("Couldn't find cell's class")
    }
}
}
