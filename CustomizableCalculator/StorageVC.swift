//
//  StorageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class StorageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    var isSlideMenuShowing = false
    var isAddMenuShowing = false
    let addButtonMenuItems = ["Camera", "Add file", "Add photo"]
    let slideMenuItems = ["Photo", "Video", "Web", "Setting"]
    
    @IBOutlet weak var slideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideMenuTableView: UITableView!
    @IBOutlet weak var addButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        slideMenuTableView.delegate = self
        slideMenuTableView.dataSource = self
        
        addButtonTableView.delegate = self
        addButtonTableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        UINavigationBar.appearance().barTintColor = UIColor.darkGray
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if isAddMenuShowing {
            toggleSlider(distance: -200, menuConstraint: addButtonTopConstraint)
        } else {
            toggleSlider(distance: 0, menuConstraint: addButtonTopConstraint)
        }
        isAddMenuShowing = !isAddMenuShowing
        if isSlideMenuShowing {
            toggleSlider(distance: -140, menuConstraint: slideMenuLeadingConstraint)
            isSlideMenuShowing = !isSlideMenuShowing
        }
    }
    
    @IBAction func slideMenuTapped(_ sender: Any) {
        if isSlideMenuShowing {
            toggleSlider(distance: -140, menuConstraint: slideMenuLeadingConstraint)
        } else {
            toggleSlider(distance: 0, menuConstraint: slideMenuLeadingConstraint)
        }
        isSlideMenuShowing = !isSlideMenuShowing
        if isAddMenuShowing {
            toggleSlider(distance: -200, menuConstraint: addButtonTopConstraint)
            isAddMenuShowing = !isAddMenuShowing
        }
    }
    
    func toggleSlider(distance: CGFloat, menuConstraint: NSLayoutConstraint) {
        menuConstraint.constant = distance
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == slideMenuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "slideMenuCell") as! SlideMenuCell
            cell.configureCell(itemName: slideMenuItems[indexPath.row])
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addButtonMenuCell") as! AddButtonMenuCell
            cell.configureCell(itemName: addButtonMenuItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == slideMenuTableView {
            return slideMenuItems.count
        } else {
            return addButtonMenuItems.count
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        <#code#>
//    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! MediaCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
