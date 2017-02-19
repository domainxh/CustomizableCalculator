//
//  StorageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVFoundation

class StorageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var mainMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var addMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainMenuTableView: UITableView!
    @IBOutlet weak var addMenuTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var addMenuView: UIView!
    @IBOutlet weak var blackView: UIView!
    
    var isMainMenuShowing = false
    var isAddMenuShowing = false
    let addMenuItems = ["Camera", "Add photo"]
    let mainMenuItems = ["Photo", "Video", "Web", "Setting"]
    
    let cellHeight: CGFloat = 50
    
    let mediaPerRow: CGFloat = 2
    let cellGap = CGFloat(2)
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    
    let storageData = StorageData()
    
    private var _titleName: String?
    var titleName: String? { set { _titleName = newValue } get { return _titleName } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleName
        
//        addMenuView.frame.height = cellHeight * addMenuitems.count
        
        mainMenuTableView.delegate = self
        mainMenuTableView.dataSource = self
        
        addMenuTableView.delegate = self
        addMenuTableView.dataSource = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 24, green: 24, blue: 24) // Hexcolor 242424
        UINavigationBar.appearance().backgroundColor = UIColor(red: 24, green: 24, blue: 24)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    func handleSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                showMainMenu()
            case UISwipeGestureRecognizerDirection.left:
                hideMainMenu()
            default:
                break
            }
        }
    }
    
    @IBAction func addMenuTapped(_ sender: Any) {
        if isAddMenuShowing {
            hideAddMenu()
            dismissBlackView()
        } else if !isAddMenuShowing && isMainMenuShowing {
            hideMainMenu()
            showAddMenu()
        } else {
            showAddMenu()
            animateBlackView()
        }
    }
    
    @IBAction func mainMenuTapped(_ sender: Any) {
        if isMainMenuShowing {
            hideMainMenu()
            dismissBlackView()
        } else if !isMainMenuShowing && isAddMenuShowing{
            showMainMenu()
            hideAddMenu()
        } else {
            showMainMenu()
            animateBlackView()
        }
    }
    
    func animateBlackView() {
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissBlackView)))
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.alpha = 1
        })
    }
    
    func dismissBlackView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.blackView.isHidden = true
            self.blackView.alpha = 0
            self.hideAddMenu()
            self.hideMainMenu()
        })
    }
    
    func hideAddMenu() {
        if isAddMenuShowing {
            toggleSlider(distance: -200, menuConstraint: addMenuConstraint)
            isAddMenuShowing = !isAddMenuShowing
        }
    }
    
    func showAddMenu() {
        if !isAddMenuShowing {
            toggleSlider(distance: 0, menuConstraint: addMenuConstraint)
            isAddMenuShowing = !isAddMenuShowing
        }
    }
    
    func hideMainMenu() {
        if isMainMenuShowing {
            toggleSlider(distance: -140, menuConstraint: mainMenuConstraint)
            isMainMenuShowing = !isMainMenuShowing
        }
    }
    
    func showMainMenu() {
        if !isMainMenuShowing {
            toggleSlider(distance: 0, menuConstraint: mainMenuConstraint)
            isMainMenuShowing = !isMainMenuShowing
        }
    }
    
    func toggleSlider(distance: CGFloat, menuConstraint: NSLayoutConstraint) {
        menuConstraint.constant = distance
        UIView.animate(withDuration: 0.3, animations: { self.view.layoutIfNeeded() })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainMenuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mainMenuCell") as! MenuCell
            cell.configCell(menuItems: mainMenuItems[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addMenuCell") as! MenuCell
            cell.configCell(menuItems: addMenuItems[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainMenuTableView {
            return mainMenuItems.count
        } else {
            return addMenuItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hideMainMenu()
        dismissBlackView()
        
        let currentCell = tableView.cellForRow(at: indexPath) as! MenuCell
        let cellText = currentCell.menuLabel.text
        
        if cellText == title {
            hideMainMenu()
            return
        } else if cellText == "Video" {
            title = "Video"
        } else if cellText == "Photo" {
            title = "Photo"
        }

        DispatchQueue.main.async(execute: {
            self.collectionView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "managePageVC") as? ManagePageVC {
            vc.mediaType = title
            vc.currentIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if title == "Photo" {
            return storageData.photos.count
        } else if title == "Video" {
            return storageData.videos.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! MediaCell
        title == "Photo" ? cell.configPhotoCell(url: storageData.photos[indexPath.row].path) : cell.configVideoCell(url: storageData.videos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = (mediaPerRow - 1) * cellGap
        let widthPerItem = (view.frame.width - paddingSpace) / mediaPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellGap
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellGap
    }
    
    
}
