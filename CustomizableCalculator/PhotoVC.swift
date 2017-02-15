//
//  PhotoVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/14/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var selectedImageURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        
        scrollView.delegate = self
        automaticallyAdjustsScrollViewInsets = false
        imageView.contentMode = .scaleAspectFit
        imageView.center = scrollView.center;
        
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
        
        imageView.image = UIImage(contentsOfFile: selectedImageURL!)
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipe))
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? { return imageView }
    
    func swipe() {
        
    }
    
}
