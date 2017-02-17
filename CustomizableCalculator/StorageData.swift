//
//  StorageData.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/17/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import Foundation

class StorageData: NSObject {
    var photoList: Array<URL>?
    var videoList: Array<URL>?
    
    init(photoList: Array<URL>, videoList: Array<URL>) {
        self.photoList = photoList
        self.videoList = videoList
    }
}
