//
//  mediaCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    
//    override func awakeFromNib() {
//        layer.cornerRadius = 5
//        layer.borderWidth = 2
//        layer.borderColor = UIColor.darkGray.cgColor
//        clipsToBounds = true
//    }

    func configureCell(URL: String) {
        cellImage.image = UIImage(contentsOfFile: URL)
    }
    
//    func configureCell(fileName: String) {
//        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        let filePath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent(fileName)
//        
//        self.handleDocumentOpenURL
//    }
//    
//    
//    func handleDocumentOpenURL(url: NSURL) {
//        let requestObj = NSURLRequest(url: url as URL)
//        webView.isUserInteractionEnabled = true
//        webView.loadRequest(requestObj as URLRequest)
//    }
//    
//    func loadFileFromDocumentsFolder(fileName: String) {
//        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//        var documentsDirectory : String;
//        documentsDirectory = paths[0] as String
//        let filePath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent(fileName)
//        
//        self.handleDocumentOpenURL(url: filePath as! NSURL)
//        
//    }
    
}
