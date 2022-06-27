//
//  UIColor+Extension.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static let customBlack      = UIColor(rgb: 0x161F28)
    static let customLightGray1 = UIColor(rgb: 0xEFF2F7)
    static let customLightGray2 = UIColor(rgb: 0x98A5BE)
    static let customLightGray3 = UIColor(rgb: 0xC1C8D7)
}
