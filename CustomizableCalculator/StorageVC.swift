//
//  StorageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class StorageVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {

    // Note that your entire app’s Documents folder will be shared when you do this, including all folders you create in it. If you have data that you do not want your users to see you need to store them outside the Documents folder, or start those file names with a “full stop” (such as .testfile). This will hide the file and hence it won’t show up in iTunes.
    
    @IBOutlet weak var slideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var slideMenuTableView: UITableView!
    @IBOutlet weak var addButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var addButtonTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!

    var isSlideMenuShowing = false
    var isAddMenuShowing = false
    let addButtonMenuItems = ["Camera", "Add file", "Add photo"]
    let slideMenuItems = ["Photo", "Video", "Web", "Setting"]
    var photoList = [URL]()
    var videoList = [String]()
    
    private let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    private var allFilesInDirectory: [URL] {
        return try! FileManager.default.contentsOfDirectory(at: documentDirectory!, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)

    }
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
        
        photoList = allPhotosFromDirectory()
        
    }
    
    fileprivate func allPhotosFromDirectory() -> [URL] {
        return allFilesInDirectory.filter({ photo in
            photo.pathExtension.lowercased() == "jpg" ||
            photo.pathExtension.lowercased() == "png" ||
            photo.pathExtension.lowercased() == "gif" ||
            photo.pathExtension.lowercased() == "jpeg" ||
            photo.pathExtension.lowercased() == "tiff" })
    }

    fileprivate func allVideoFromDirectory() -> [URL] {
        return allFilesInDirectory.filter({ video in
            video.pathExtension.lowercased() == "avi" ||
            video.pathExtension.lowercased() == "mov" ||
            video.pathExtension.lowercased() == "mp4" ||
            video.pathExtension.lowercased() == "m4v" })
    }
    
    
//        var filterArray = allFiles.map(){ $0.lastPathComponent }.filter(){ $0.pathExtension == "jpg" } as [String]
        //        println("filter array \(allFiles[3])")
//        var superURL: NSURL!
//        for itemInFilterArray in filterArray {
//            var direct = fileManager.URLsForDirectory(FileManager.SearchPathDirectory.DocumentDirectory, inDomains: FileManager.SearchPathDomainMask.UserDomainMask)
//            if var url: NSURL = direct.first as? NSURL {
//                superURL = url.appendingPathComponent(itemInFilterArray) as NSURL!
//            }
//            var playerItem = AVPlayerItem(URL: superURL)
//            var equalazerString: String!
//            var commonMetaData = playerItem.asset.commonMetadata as! [AVMetadataItem]
//            for item in commonMetaData {
//                if item.commonKey == "title" {
//                    equalazerString = item.stringValue
//                    if equalazerString == currentSongString {
//                        localArrayNames.append(superURL)
//                    } else {
//                        //                        println("it is not equals")
//                    }
//                }
//            }
//        }
    
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
        return photoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mediaCell", for: indexPath) as! MediaCell
        cell.configureCell(URL: photoList[indexPath.row].path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
