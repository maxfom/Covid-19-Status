//
//  CountriesViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit
import RealmSwift

class CountriesViewController: BaseTableViewController {

    // MARK: - Private
    private enum Spec {
        enum NewItemAlert {
            static let title = "Add country"
            static let message = "Input your country here"
            enum CancelButton {
                static let title = "Cancel"
            }
            enum OkButton {
                static let title = "Save"
            }
            enum TextField {
                static let placeholder = "ex. Russia"
            }
        }
    }
    
    var items: Results<CountryItem> = RealmService.getCountries()
    private var token: NotificationToken?
    //private let weatherService = WeatherService()
    
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
    
    @IBAction func addNewCountryItem() {
        showAlert(
            title: Spec.NewItemAlert.title,
            message: Spec.NewItemAlert.message,
            cancelButton: Spec.NewItemAlert.CancelButton.title,
            okButton: Spec.NewItemAlert.OkButton.title,
            okAction: { [weak self] itemTitle in
                guard let self = self,
                      let itemTitle = itemTitle
                else {
                    return
                }
                self.getCountry(country: itemTitle) { country in
                    guard let country = country else { return }
                    RealmService.saveCountry(country: country)
                }
            },
            hasTextField: true,
            textFieldPlaceholder: Spec.NewItemAlert.TextField.placeholder
        )
    }
    
    func getCountry(country: String, completion: @escaping (CountryItem?) -> Void) {
        weatherService.getCountry(country: country) { [weak self] result in
           switch result {
           case .success(let country):
               completion(country)

           case .failure(let error):
               completion(nil)
               self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
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
            cell.configure(title: item.title)
            return cell
        }
        
        fatalError("Couldn't find cell's class")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let country = items[indexPath.row].title
        guard let vc = storyboard?.instantiateViewController(identifier: "CovidStatusViewController") as? CovidStatusViewController else { return }
        vc.configure(country: country)
        show(vc, sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            RealmService.removeCountry(items[indexPath.row])
            
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
