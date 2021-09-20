//
//  ImageHeaderCollectionReusableView.swift
//  Covid-19-Status
//
//  Created by Георгий Сабанов on 24.08.2021.
//

import UIKit

class ImageHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var headerTop: UIImageView!
    var headerURL: URL?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        headerURL = URL(string: RealmService.getImageInfo().first?.imageCountry ?? "")
        headerTop.loadImage(withUrl: headerURL ?? URL.init(fileURLWithPath: ""))
        print(headerURL)
        //headerTop.loadImge(withUrl: FavoriteCountryInfoViewController.imageURL ?? URL.init(fileURLWithPath: ""))
        
        // Initialization code
    }
}

extension UIImageView {
    func loadImage(withUrl url: URL) {
        DispatchQueue.main.async { [weak self] in
               if let imageData = try? Data(contentsOf: url) {
                   if let image = UIImage(data: imageData) {
                       DispatchQueue.main.async {
                           self?.image = image
                       }
                   }
               }
           }
       }
}
