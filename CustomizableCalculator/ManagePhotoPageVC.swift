//
//  ManagePhotoPageVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/14/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class ManagePhotoPageVC: UIPageViewController, UIPageViewControllerDataSource {

    var photoList: [URL]?
    var currentIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        automaticallyAdjustsScrollViewInsets = false
        
        if let viewController = viewPhotoCommentController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
    func viewPhotoCommentController(_ index: Int) -> PhotoVC? {
        if let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "photoVC") as? PhotoVC {
            page.currentIndex = index
            page.photoList = photoList
            return page
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? PhotoVC {
            var index = viewController.currentIndex
            guard index != NSNotFound && index != 0 else { return nil }
            index = index! - 1
            return viewPhotoCommentController(index!)
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let viewController = viewController as? PhotoVC {
            var index = viewController.currentIndex
            guard index != NSNotFound else { return nil }
            index = index! + 1
            guard index != photoList?.count else {return nil}
            return viewPhotoCommentController(index!)
        }
        return nil
    }

}
