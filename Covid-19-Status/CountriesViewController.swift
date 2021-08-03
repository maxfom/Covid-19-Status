//
//  CountriesViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit
import RealmSwift

class CountriesViewController: BaseTableViewController {

    var searchText: String = "" {
        didSet {
            if searchText.isEmpty {
                items = RealmService.getCountries()
            } else {
                items = RealmService.getCountries().filter("country CONTAINS[cd] %@", searchText)
            }
        }
    }
    var onCountrySelected: (CountryItem) -> Void = { _ in }
    var items: Results<CountryItem> = RealmService.getCountries() {
        didSet {
            token?.invalidate()
            token = items.observe(
                on: .main,
                { [weak self] changes in
                    guard let tableView = self?.tableView else { return }
                    tableView.reloadData()
                }
            )
        }
    }
    private var token: NotificationToken?
    private let countryService = CountryService()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        token = items.observe(
            on: .main,
            { [weak self] changes in
                guard let tableView = self?.tableView else { return }
                tableView.reloadData()
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCountries() { countries in
            guard let countries = countries else { return }
            RealmService.saveCountries(countries: countries)
        }
    }
    
    func getCountries(completion: @escaping ([CountryItem]?) -> Void) {
        countryService.getCountries() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    completion(countries)
                    
                case .failure(let error):
                    completion(nil)
                    self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
                }
            }
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension CountriesViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.cellIdentifier, for: indexPath) as? CountryTableViewCell {
            let item = items[indexPath.row]
            cell.configure(title: item.country)
            return cell
        }
        
        fatalError("Couldn't find cell's class")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        onCountrySelected(items[indexPath.row])
    }
        
}

