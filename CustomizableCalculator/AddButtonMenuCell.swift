//
//  AddButtonMenuCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class AddButtonMenuCell: UITableViewCell {

    
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var itemImage: UIImageView!

    func configureCell(itemName: String) {
        itemLabel.text = itemName
        itemImage.image = UIImage(named: itemName)
    }

}
