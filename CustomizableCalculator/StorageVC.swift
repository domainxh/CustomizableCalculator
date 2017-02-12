//
//  StorageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class StorageVC: UIViewController {

    var isMenuShowing = false
    @IBOutlet weak var slideMenuLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UINavigationBar.appearance().barTintColor = UIColor.darkGray
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

    }

    @IBAction func slideMenuTapped(_ sender: Any) {
        if isMenuShowing {
            slideMenuLeadingConstraint.constant = -140
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        } else {
            slideMenuLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        }
        isMenuShowing = !isMenuShowing
    }

}
