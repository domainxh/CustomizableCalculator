//
//  mediaCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
    override func awakeFromNib() {
//        layer.cornerRadius = 5
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.darkGray.cgColor
        clipsToBounds = true
    }

    func configureCell(URL: String) {
        cellImage.image = UIImage(contentsOfFile: URL)
    }
    
    
}
