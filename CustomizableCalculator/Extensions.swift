//
//  Extensions.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.characters.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }

    subscript (r: Range<Int>) -> String {
        return substring(with: characters.index(startIndex, offsetBy: r.lowerBound) ..< characters.index(startIndex, offsetBy: r.upperBound))
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    // Usage
    // var color = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF)
    // var color2 = UIColor(netHex:0xFFFFFF)
}

