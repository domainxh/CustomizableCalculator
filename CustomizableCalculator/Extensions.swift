//
//  Extensions.swift
//  CustomizableCalculator
//
//  Created by Xiaoheng Pan on 2/9/17.
//  Copyright © 2017 Xiaoheng Pan. All rights reserved.
//

import Foundation

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

//extension UserDefaults {
//    func setPassword(password: String) {
//        set(password, forKey: "password")
//        synchronize()
//    }
//    
//    func isPasswordSet() -> Bool {
//        return bool(forKey: "isPasswordSet")
//    }
//    
//}
