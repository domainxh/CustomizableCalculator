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
    
    @IBOutlet weak var slideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideMenuTableView: UITableView!
    @IBOutlet weak var addButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var isSlideMenuShowing = false
    var isAddMenuShowing = false
    let addButtonMenuItems = ["Camera", "Add file", "Add photo"]
    let slideMenuItems = ["Photo", "Video", "Web", "Setting"]
    let mediaPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 2.0, left: 2.0, bottom: 0.0, right: 2.0)
    
    private var _titleName: String?
    var titleName: String? { set { _titleName = newValue } get { return _titleName } }
    
    fileprivate var photoList = [URL]()
    fileprivate var videoList = [URL]()
    fileprivate let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    fileprivate var allFilesInDirectory: [URL] {
        return try! FileManager.default.contentsOfDirectory(at: documentDirectory!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = titleName

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
        
        if title == "Photo" {
            photoList = allPhotosFromDirectory()
        } else if title == "Video" {
            videoList = allVideosFromDirectory()
        }
        
    }
    
    fileprivate func allPhotosFromDirectory() -> [URL] {
        return allFilesInDirectory.filter({ photo in
            photo.pathExtension.lowercased() == "jpg" ||
            photo.pathExtension.lowercased() == "png" ||
            photo.pathExtension.lowercased() == "gif" ||
            photo.pathExtension.lowercased() == "jpeg" ||
            photo.pathExtension.lowercased() == "tiff" })
    }

    fileprivate func allVideosFromDirectory() -> [URL] {
        return allFilesInDirectory.filter({ video in
            video.pathExtension.lowercased() == "avi" ||
            video.pathExtension.lowercased() == "mov" ||
            video.pathExtension.lowercased() == "mp4" ||
            video.pathExtension.lowercased() == "m4v" ||
            video.pathExtension.lowercased() == "vob" ||
            video.pathExtension.lowercased() == "mpg" ||
            video.pathExtension.lowercased() == "mpeg" })
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
        
//        tableView == slideMenuTableView ? return slideMenuItems.count : return addButtonMenuItems.count
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//    }
//    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "managePageVC") as? ManagePageVC {
            if title == "Photo" {
                vc.photoList = photoList
            } else if title == "Video" {
                vc.videoList = videoList
            }
            vc.currentIndex = indexPath.row
            navigationController?.pushViewController(vc, animated: true)
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if title == "Photo" {
            return photoList.count
        } else if title == "Video" {
            return videoList.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! MediaCell
        title == "Photo" ? cell.configPhotoCell(url: photoList[indexPath.row].path) : cell.configVideoCell(url: videoList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = (mediaPerRow + 1) * sectionInsets.left
        let widthPerItem = (view.frame.width - paddingSpace) / mediaPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
