//
//  slideMenuCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/11/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class SlideMenuCell: UITableViewCell {

    @IBOutlet weak var slideMenuIcon: UIImageView!
    @IBOutlet weak var slideMenuLabel: UILabel!
    
    func configureCell(itemName: String) {
        slideMenuLabel.text = itemName
        slideMenuIcon.image = UIImage(named: itemName)
    }

}
