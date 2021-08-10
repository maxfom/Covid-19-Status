//
//  CovidStatusViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class CovidStatusViewController: BaseTableViewController {

    private var country: String = ""
    private var statis: StatsCountryItem?
    private var token: NotificationToken?
    private let countryService = CountryService()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statis = RealmService.getStatsOfCountry(for: country)
        let countryObject = try! Realm().object(ofType: StatsCountryItem.self, forPrimaryKey: country)
        token = countryObject?
            .observe(on: .main) { [weak self] change in
                switch change {
                case .change(_, let properties):
                    for property in properties {
                        if property.name == "currentStats" {
                            self?.statis = property.newValue as? StatsCountryItem
                            self?.tableView.reloadData()
                        }
                    }
                    
                case .deleted:
                    self?.navigationController?.popViewController(animated: true)
                    
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
    }
    
    func configure(country: String) {
        self.country = country
    }
    
    func getStatsOfCountry(completion: @escaping ([StatsCountryItem]?) -> Void) {
        countryService.getStatsOfCountry(country: country) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let statis):
                    completion(statis)
                    
                case .failure(let error):
                    completion(nil)
                    self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
                }
            }
        }
    }
}

extension CovidStatusViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if statis == nil {
            return 0
        } else {
            return 4
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let statis = statis else { return UITableViewCell() }

        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: CovidStatusViewCell.cellIdentifier, for: indexPath) as? CovidStatusViewCell {
                switch indexPath.row {
                case 0:
                    cell.configure(title: "Подтверждено: \(statis.confirmed) ºC")

                case 1:
                    cell.configure(title: "Смертей: \(statis.deaths)")

                case 2:
                    cell.configure(title: "Выздоровили: \(statis.recovered)")

                case 3:
                    cell.configure(title: "Страна: \(statis.country)")

                default:
                    break
                }
                return cell
            }
        }

        fatalError("Couldn't find cell's class")
    }
}
