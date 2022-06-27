//
//  UIImageExtension.swift
//  ContactList
//
//  Created by Bogdan on 27.06.2022.
//

import UIKit

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard (image?.cgImage) != nil else { return nil }
        self.init(cgImage: image!.cgImage!)
    }
}
