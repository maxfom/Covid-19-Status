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

    private var country: CountryItem!
    private var status: Results<StatsCountryItem>!
    private var token: NotificationToken?
    private let countryService = CountryService()
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        token = status.observe(
            on: .main,
            { [weak self] changes in
                guard let tableView = self?.tableView else { return }
                switch changes {
                case .initial:
                    // Results are now populated and can be accessed without blocking the UI
                    tableView.reloadData()
                case .update(_, let deletions, let insertions, let modifications):
                    // Query results have changed, so apply them to the UITableView
                    tableView.performBatchUpdates({
                        // Always apply updates in the following order: deletions, insertions, then modifications.
                        // Handling insertions before deletions may result in unexpected behavior.
                        tableView.deleteSections(IndexSet(deletions), with: .automatic)
                        tableView.insertSections(IndexSet(insertions), with: .automatic)
                        tableView.reloadSections(IndexSet(modifications), with: .automatic)
                    }, completion: { finished in
                        // ...
                    })
                case .error(let error):
                    // An error occurred while opening the Realm file on the background worker thread
                    fatalError("\(error)")
                }
            }
        )
    }
    
    func configure(country: CountryItem) {
        self.country = country
        status = country.currentStats.sorted(byKeyPath: "date", ascending: false)
        getStatsOfCountry { stats in
            guard let stats = stats else { return }
            DispatchQueue.main.async {
                RealmService.saveStatsOfCountry(stats, to: country)
            }
        }
    }
    
    func getStatsOfCountry(completion: @escaping ([StatsCountryItem]?) -> Void) {
        countryService.getStatsOfCountry(country: country.country) { [weak self] result in
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
        if status == nil {
            return 0
        } else {
            return status.count
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if status == nil {
            return 0
        } else {
            return 4
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CovidStatusViewCell.cellIdentifier, for: indexPath) as? CovidStatusViewCell
        else {
            fatalError("Couldn't find cell's class")
        }
        let status = status[indexPath.section]
        switch indexPath.row {
        case 0:
            cell.configure(title: "Подтверждено: \(status.confirmed)")
            
        case 1:
            cell.configure(title: "Смертей: \(status.deaths)")
            
        case 2:
            cell.configure(title: "Выздоровили: \(status.recovered)")
            
        case 3:
            cell.configure(title: "Страна: \(status.country)")
            
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let status = status[section]
        return dateFormatter.string(from: status.date)
    }
    
}
