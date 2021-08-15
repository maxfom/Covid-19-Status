//
//  FavoriteCountryInfoViewController.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 13.08.2021.
//

import UIKit

class FavoriteCountryInfoViewController: UIViewController {
    
    var country: CountryItem!
    var collectionView: UICollectionView!
    var countryTitle: String = ""
    var monthStat = "Статистика за месяц"
    var weekStat = "Статистика за неделю"
    var dayStat = "Статистика за вчера"
    var allStat = "Статистика за все время"
    
    var today: String = ""
    var fromMonth: String = ""
    var fromWeek: String = ""
    var fromDay: String = ""
    var allTime: String = ""
    
    override func loadView() {
        super.loadView()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
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
        today = getYesterday()
        fromMonth = getMonthFromToday()
        fromWeek = getWeekFromToday()
        fromDay = getTwoDays()
        navigationItem.title = countryTitle
        self.collectionView.backgroundColor = .white
        self.collectionView.dataSource = self
               self.collectionView.delegate = self

               self.collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

    }
    
    func configure(country: CountryItem) {
        countryTitle = country.country
        self.country = country
    }
    
    //MARK: - Получение даты - переписать в одну функцию
    
    func getYesterday() -> String {
        let today = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:00'Z'"
        return formatter.string(for: yesterday) ?? ""
    }
    
    func getMonthFromToday() -> String {
        let today = Date()
        let month = Calendar.current.date(byAdding: .month, value: -1, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:00'Z'"
        return formatter.string(for: month) ?? ""
    }
    
    func getWeekFromToday() -> String {
        let today = Date()
        let week = Calendar.current.date(byAdding: .day, value: -7, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:00'Z'"
        return formatter.string(for: week) ?? ""
    }
    
    func getTwoDays() -> String {
        let today = Date()
        let week = Calendar.current.date(byAdding: .day, value: -2, to: today)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'00:00:00'Z'"
        return formatter.string(for: week) ?? ""
    }
    
}


extension FavoriteCountryInfoViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        switch indexPath.row {
        case 0:
            cell.labelCell.text = monthStat
        case 1:
            cell.labelCell.text = weekStat
        case 2:
            cell.labelCell.text = dayStat
        case 3:
            cell.labelCell.text = allStat
        default: cell.labelCell.text = String(indexPath.row + 1)
        }
        return cell
    }
}

extension FavoriteCountryInfoViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(identifier: "CovidStatusViewController") as? CovidStatusViewController else { return }
        switch indexPath.row {
        case 0:
            vc.sentTime(toPeriod: today, fromPeriod: fromMonth)
        case 1:
            vc.sentTime(toPeriod: today, fromPeriod: fromWeek)
        case 2:
            vc.sentTime(toPeriod: today, fromPeriod: fromDay)
        default:
            vc.sentTime(toPeriod: today, fromPeriod: allTime)
        }
        vc.configure(country: country)
        show(vc, sender: self)
    }
}


extension FavoriteCountryInfoViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.bounds.size.width - 16, height: 120)
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
}
