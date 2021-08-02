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
    private var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    
    func configure(country: String) {
        self.country = country
    }
    
}
