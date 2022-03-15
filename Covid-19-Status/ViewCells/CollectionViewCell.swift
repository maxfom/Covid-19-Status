//
//  CollectionViewCell.swift
//  Covid-19-Status
//
//  Created by Максим Фомичев on 14.08.2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var labelCell: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let labelCell = UILabel(frame: .zero)
        labelCell.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(labelCell)
        NSLayoutConstraint.activate([
            labelCell.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            labelCell.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            labelCell.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            labelCell.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        self.labelCell = labelCell
        
        self.contentView.backgroundColor = UIColor(red: 139/255, green: 169.0/255, blue: 189.0/255, alpha: 1.0)
        self.labelCell.textColor = .white
        self.labelCell.textAlignment = .center
        self.labelCell.lineBreakMode = .byWordWrapping
        self.labelCell.numberOfLines = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        fatalError("Interface Builder is not supported!")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        fatalError("Interface Builder is not supported!")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.labelCell.text = nil
    }
}
