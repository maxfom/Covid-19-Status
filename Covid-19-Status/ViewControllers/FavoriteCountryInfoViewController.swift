//
//  FavoriteCountryInfoViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 13.08.2021.
//

import UIKit
import RealmSwift

class FavoriteCountryInfoViewController: UIViewController {
    
    enum Period: Int, CaseIterable {
        case day, week, month, allTime
        
        var title: String {
            switch self {
            case .month:
                return "Статистика за месяц"
                
            case .week:
                return "Статистика за неделю"

            case .day:
                return "Статистика за 2 дня"

            case .allTime:
                return "Статистика за все время"

            }
        }
        
        var dateOffset: (Calendar.Component, Int)? {
            switch self {
            case .day:
                return (.day, -2)
                
            case .month:
                return (.month, -1)

            case .week:
                return (.day, -7)

            case .allTime:
                return nil
            }
        }
    }
    
    var country: CountryItem!
    var imageCountryService = ImageCountryService()
    var countryInfo: Results<CountryImageItem> = RealmService.getImageInfo()
    var collectionView: UICollectionView!
    var countryTitle: String = ""
    var periods = Period.allCases
    var periodCache: [Period: String] = [:]
    var today: String?
    
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
        for period in periods {
            guard let (component, value) = period.dateOffset
            else {
                periodCache[period] = ""
                continue
            }
            periodCache[period] = getDateWithOffset(byAdding: component, value: value)
        }
        navigationItem.title = countryTitle
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        self.collectionView.register(
            UINib(nibName: "ImageHeaderCollectionReusableView", bundle: nil),
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "ImageHeader"
        )
        
        self.getImageCountry() { countryInfo in
            guard let countryInfo = countryInfo else { return }
            RealmService.saveImageInfo(countryInfo: countryInfo)
        }
        print(countryInfo.first?.imageCountry)
    }
    
    func getImageCountry(completion: @escaping ([CountryImageItem]?) -> Void) {
        imageCountryService.getImageCountry() { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countryInfo):
                    completion(countryInfo)
                    print(countryInfo)
                case .failure(let error):
                    completion(nil)
                    self?.showAlert(title: "Error", message: error.localizedDescription, cancelButton: "OK")
                }
            }
        }
    }
    
    
    func configure(country: CountryItem) {
        countryTitle = country.country
        self.country = country
    }
    
    //MARK: - Получение даты - в одну функцию
    func getDateWithOffset(byAdding component: Calendar.Component, value: Int) -> String {
        let today = Date()
        let week = Calendar.current.date(byAdding: component, value: value, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:00'Z'"
        return formatter.string(for: week) ?? ""
    }
    
}


extension FavoriteCountryInfoViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 0
        case 1:
            return periods.count
        default:
            return periods.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.labelCell.text = periods[indexPath.row].title
        return cell
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

extension FavoriteCountryInfoViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "CovidStatusViewController") as? CovidStatusViewController else { return }
        guard indexPath.section > 0 else { return }
        if today == nil {
            today = getDateWithOffset(byAdding: .day, value: -1)
        }
        let period = periods[indexPath.row]
        guard let today = today, let cachedDate = periodCache[period] else { return }
        vc.configure(country: country, toPeriod: today, fromPeriod: cachedDate)
        show(vc, sender: self)
    }
    
}


extension FavoriteCountryInfoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 20) / 2.0
        return CGSize(width: width, height: 120)
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
