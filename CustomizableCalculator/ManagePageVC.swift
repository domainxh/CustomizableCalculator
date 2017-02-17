//
//  ManagePhotoPageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/14/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class ManagePageVC: UIPageViewController, UIPageViewControllerDataSource {
    
    var photoList: [URL]?
    var videoList: [URL]?
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
//        automaticallyAdjustsScrollViewInsets = false
        
        if let viewController = viewMediaController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
    func viewMediaController(_ index: Int) -> UIViewController? {
        
        if photoList != nil {
            if let storyboard = storyboard,
                let page = storyboard.instantiateViewController(withIdentifier: "photoVC") as? PhotoVC {
                page.currentIndex = index
                page.photoList = photoList
                return page
            }
        } else {
            if let storyboard = storyboard,
                let page = storyboard.instantiateViewController(withIdentifier: "videoVC") as? VideoVC {
                page.currentIndex = index
                page.videoList = videoList
                return page
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if photoList != nil {
            if let viewController = viewController as? PhotoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound && index != 0 else { return nil }
                index! -= 1
                return viewMediaController(index!)
            }
        } else {
            if let viewController = viewController as? VideoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound && index != 0 else { return nil }
                index! -= 1
                return viewMediaController(index!)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if photoList != nil {
            if let viewController = viewController as? PhotoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound else { return nil }
                index! += 1
                guard index != photoList?.count else {return nil}
                return viewMediaController(index!)
            }
        } else {
            if let viewController = viewController as? VideoVC {
                var index = viewController.currentIndex
                guard index != NSNotFound else { return nil }
                index! += 1
                guard index != videoList?.count else {return nil}
                
                return viewMediaController(index!)
            }
        }
        return nil
    }
    
}
