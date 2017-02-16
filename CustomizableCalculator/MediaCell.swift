//
//  mediaCell.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/12/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import UIKit
import AVFoundation

class MediaCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var videoDurationLabel: UILabel!
    
    func configPhotoCell(url: String) {
        videoDurationLabel.isHidden = true
        cellImage.contentMode = .scaleAspectFill
        cellImage.image = UIImage(contentsOfFile: url)
    }
    
    func configVideoCell(url: URL) {
        
        do {
            let asset = AVURLAsset(url: url , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            
            cellImage.image = UIImage(cgImage: cgImage)
            
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        
        videoDurationLabel.text = getMediaDuration(url: url as NSURL!)
    }
    
    func getMediaDuration(url: NSURL!) -> String{
        let asset : AVURLAsset = AVURLAsset(url: url as URL) as AVURLAsset
        let duration : CMTime = asset.duration
        
        let durationSeconds = CMTimeGetSeconds(duration);
        let secondsString = String(format: "%02d", Int(durationSeconds.truncatingRemainder(dividingBy: 60)))
        let minutesString = String(format: "%02d", Int(durationSeconds / 60))
        
        return "\(minutesString):\(secondsString)"
    }
    
}
