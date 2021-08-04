//
//  CountriesViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit
import RealmSwift

class FavoriteCountriesViewController: BaseTableViewController {

    var items: Results<CountryItem> = RealmService.getFavoriteCountries()
    private var token: NotificationToken?
    private let countryService = CountryService()
    private let resultsController = UIStoryboard(
        name: "Main",
        bundle: nil
    ).instantiateViewController(withIdentifier: "Countries") as? CountriesViewController
    
    private lazy var searchController = UISearchController(
        searchResultsController: resultsController
    )
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        token = items.observe(
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
                        tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                             with: .automatic)
                        tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        token?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search countries"
        searchController.showsSearchResultsController = true
        resultsController?.onCountrySelected = { [weak self] country in
            RealmService.addFavoriteCountry(slug: country.slug)
            self?.searchController.dismiss(animated: true, completion: nil)
            self?.searchController.searchBar.text = ""
            self?.resultsController?.searchText = ""
        }
        navigationItem.searchController = searchController
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
extension FavoriteCountriesViewController {
    
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
        let country = items[indexPath.row].country
        guard let vc = storyboard?.instantiateViewController(identifier: "CovidStatusViewController") as? CovidStatusViewController else { return }
        vc.configure(country: country)
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            RealmService.removeFavoriteCountry(slug: items[indexPath.row].slug)
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
        
}

extension FavoriteCountriesViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsController?.searchText = searchText
    }
    
}

