//
//  UIColor+Ext.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/21.
//

import Foundation
import UIKit

extension UIColor {
    static let backgroundWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    static let backgroundGray = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
    
}

extension UIColor {
    static var gradientDarkGrey: UIColor {
        return UIColor(red: 239 / 255.0, green: 241 / 255.0, blue: 241 / 255.0, alpha: 1)
    }

    static var gradientLightGrey: UIColor {
        return UIColor(red: 201 / 255.0, green: 201 / 255.0, blue: 201 / 255.0, alpha: 1)
    }
}
