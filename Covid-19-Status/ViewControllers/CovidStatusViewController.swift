//
//  CovidStatusViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit
import SwiftyJSON
import RealmSwift

class CovidStatusViewController: UIViewController {

    private var country: CountryItem!
    private var status: Results<StatsCountryItem>!
    private var token: NotificationToken?
    private let countryService = CountryService()
    private var collectionView: UICollectionView!
    private var toPeriod: String = ""
    private var fromPeriod: String = ""
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        df.timeStyle = .none
        return df
    }()
    private let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.generatesDecimalNumbers = true
        nf.numberStyle = .decimal
        return nf
    }()
    
    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.bounces = true
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        self.collectionView = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CellStatus")
        self.collectionView.register(
            UINib(nibName: "ImageHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "ImageHeader"
        )
    }
    
    func configure(country: CountryItem, toPeriod: String, fromPeriod: String) {
        self.country = country
        self.fromPeriod = fromPeriod
        self.toPeriod = toPeriod
        status = country.currentStats.sorted(byKeyPath: "date", ascending: false)
        getStatsOfCountry { stats in
            guard let stats = stats else { return }
            DispatchQueue.main.async {
                RealmService.saveStatsOfCountry(stats, to: country)
            }
        }
    }
        
    func getStatsOfCountry(completion: @escaping ([StatsCountryItem]?) -> Void) {
        countryService.getStatsOfCountry(country: country.country, from: fromPeriod, to: toPeriod) { [weak self] result in
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

//extension CovidStatusViewController: UICollectionViewDataSource {
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        status != nil ? status.count : 0
//    }
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch section {
//        case 0:
//            return 1
//        case 1:
//            return status.count
//        default:
//            return status.count
//        }
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellStatus", for: indexPath) as? CollectionViewCell
//        else {
//            fatalError("Couldn't find cell's class")
//        }
//        let status = status[indexPath.section]
//        switch indexPath.row {
//        case 0:
//            cell.labelCell.text = "status.confirmed"
//            cell.layer.borderWidth = 0.5
//            cell.backgroundColor = UIColor(red: 102/255, green: 153.0/255, blue: 204.0/255, alpha: 1.0)
////        case 1:
////            cell.labelCell.text(title: "Смертей: \(status.deaths)")
////
////        case 2:
////            cell.labelCell.text(title: "Выздоровили: \(status.recovered)")
////
////        case 3:
////            cell.labelCell.text(title: "Страна: \(status.country)")
//
//        default:
//            break
//        }
//        return cell
//    }
//
////    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        let status = status[section]
////        return dateFormatter.string(from: status.date)
////    }
//
//}



extension CovidStatusViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return status.count
        default:
            return status.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellStatus", for: indexPath) as! CollectionViewCell
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                cell.labelCell.text = numberFormatter.string(from: 50000)
            case 1:
                cell.labelCell.text = numberFormatter.string(from: 300000)
            case 2:
                cell.labelCell.text = numberFormatter.string(from: 10000000)
            default:
                cell.labelCell.text = numberFormatter.string(from: 0)
            }
            cell.layer.borderWidth = 0.5
            cell.backgroundColor = UIColor(red: 102/255, green: 153.0/255, blue: 204.0/255, alpha: 1.0)
            cell.layer.cornerRadius = 30
            return cell
        }
        else {
            cell.labelCell.text = numberFormatter.string(from: NSNumber(value:(status[indexPath.row].confirmed)))
            //cell.labelCell.text = String(status[indexPath.row].confirmed)
            return cell
        }
        
    }
        
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              indexPath.section == 0
        else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ImageHeader", for: indexPath) as! ImageHeaderCollectionReusableView
        return header
    }
    
}

extension CovidStatusViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
    }
    
}


extension CovidStatusViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let width = (view.frame.width - 20) / 3.0
            return CGSize(width: width, height: 120)
        }
            else {
                let width = (view.frame.width - 20) / 2.0
                return CGSize(width: width, height: 120)
            }
    }
        
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 200)
        }
        return .zero
    }
    
}

