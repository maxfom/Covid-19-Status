//
//  CountryTableViewCell.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 25.07.2021.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Private
    private enum Spec {

    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
}

extension CountryTableViewCell {
    
    static var cellIdentifier: String {
        return "CountryTableViewCell"
    }
    
}
