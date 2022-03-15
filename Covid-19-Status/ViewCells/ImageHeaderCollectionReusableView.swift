//
//  ImageHeaderCollectionReusableView.swift
//  Covid-19-Status
//
//  Created by Георгий Сабанов on 24.08.2021.
//

import UIKit
import Kingfisher

class ImageHeaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var headerTop: UIImageView!
    var headerURL: URL?
        
    func configure(url: URL?) {
        headerURL = url
        headerTop.kf.setImage(with: url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        headerTop.kf.cancelDownloadTask()
        headerTop.image = nil
    }
    
}
