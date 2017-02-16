//
//  VideoVC.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/15/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoVC: AVPlayerViewController, AVPlayerViewControllerDelegate {

    var videoList: [URL]!
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playVideo()
    }
    
    func playVideo() {
        player = AVPlayer(url: videoList[currentIndex])
        player?.play()
    }
    
}
