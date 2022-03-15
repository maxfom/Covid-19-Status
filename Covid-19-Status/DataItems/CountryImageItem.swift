//
//  CountryImageItem.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 31.08.2021.
//

import Foundation
import RealmSwift

class CountryImageItem: Object {

    @objc dynamic var imageDescription: String = ""
    @objc dynamic var imageCountry: String = ""

    override class func primaryKey() -> String? {
        return "imageDescription"
    }

    convenience init(
        imageDescription: String,
        imageCountry: String
    )
    {
        self.init()
        self.imageDescription = imageDescription
        self.imageCountry = imageCountry
    }

}
