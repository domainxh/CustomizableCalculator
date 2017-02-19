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
    
    @IBOutlet weak var mainMenuTableView: UITableView!
    @IBOutlet weak var addMenuTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var addMenuView: UIView!
    @IBOutlet weak var blackView: UIView!
    @IBOutlet weak var addMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var addMenuHeightConstraint: NSLayoutConstraint!
    
    
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
        
        addMenuHeight.constant = cellHeight * CGFloat(addMenuItems.count)
        addMenuHeightConstraint.constant = cellHeight * CGFloat(addMenuItems.count) * CGFloat(-1)
        
        title = titleName
        
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
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture))
        swipeUp.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUp)
    }
    
    func handleSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                showMainMenu()
                showBlackView()
            case UISwipeGestureRecognizerDirection.left:
                hideMainMenu()
                hideBlackView()
            case UISwipeGestureRecognizerDirection.up:
                hideAddMenu()
                hideBlackView()
            default:
                break
            }
        }
    }
    
    @IBAction func addMenuTapped(_ sender: Any) {
        if isAddMenuShowing {
            hideAddMenu()
            hideBlackView()
        } else if !isAddMenuShowing && isMainMenuShowing {
            hideMainMenu()
            showAddMenu()
        } else {
            showAddMenu()
            showBlackView()
        }
    }
    
    @IBAction func mainMenuTapped(_ sender: Any) {
        if isMainMenuShowing {
            hideMainMenu()
            hideBlackView()
        } else if !isMainMenuShowing && isAddMenuShowing{
            showMainMenu()
            hideAddMenu()
        } else {
            showMainMenu()
            showBlackView()
        }
    }
    
    func showBlackView() {
        blackView.isHidden = false
        blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideBlackView)))
        blackView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 1
        })
    }
    
    func hideBlackView() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.isHidden = true
            self.blackView.alpha = 0
            self.hideAddMenu()
            self.hideMainMenu()
        })
    }
    
    func showAddMenu() {
        if !isAddMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let x = collectionView.frame.width - addMenuView.frame.width
                let yFinal = window.frame.height - collectionView.frame.height
                let yInit = yFinal - addMenuView.frame.height
                addMenuView.frame = CGRect(x: x, y: yInit, width: addMenuView.frame.width, height: addMenuView.frame.height)
            
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.addMenuView.frame = CGRect(x: x, y: yFinal, width: self.addMenuView.frame.width, height: self.addMenuView.frame.height)
                })
            }
            isAddMenuShowing = !isAddMenuShowing
        }
    }
    
    func hideAddMenu() {
        if isAddMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let x = collectionView.frame.width - addMenuView.frame.width
                let yInit = window.frame.height - collectionView.frame.height - addMenuView.frame.height
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.addMenuView.frame = CGRect(x: x, y: yInit, width: self.addMenuView.frame.width, height: self.addMenuView.frame.height)
                })
            }
            isAddMenuShowing = !isAddMenuShowing
        }
    }
    
    func showMainMenu() {
        if !isMainMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let y = window.frame.height - collectionView.frame.height
                let xInit = mainMenuView.frame.width * -1
                mainMenuView.frame = CGRect(x: xInit, y: y, width: mainMenuView.frame.width, height: mainMenuView.frame.height)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.mainMenuView.frame = CGRect(x: 0, y: y, width: self.mainMenuView.frame.width, height: self.mainMenuView.frame.height)
                })
            }
            isMainMenuShowing = !isMainMenuShowing
        }
    }
    
    func hideMainMenu() {
        if isMainMenuShowing {
            if let window = UIApplication.shared.keyWindow {
                let y = window.frame.height - collectionView.frame.height
                let xInit = mainMenuView.frame.width * -1
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    self.mainMenuView.frame = CGRect(x: xInit, y: y, width: self.mainMenuView.frame.width, height: self.mainMenuView.frame.height)
                })
            }
            isMainMenuShowing = !isMainMenuShowing
        }
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
        hideBlackView()
        
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
