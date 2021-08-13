//
//  CovidStatusViewCell.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 10.08.2021.
//

import Foundation
import UIKit

class CovidStatusViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Private
    private enum Spec {

    }

    func configure(title: String) {
        titleLabel.text = title
    }
    
}

extension CovidStatusViewCell {
    
    static var cellIdentifier: String {
        return "CovidStatusViewCell"
    }
    
}
