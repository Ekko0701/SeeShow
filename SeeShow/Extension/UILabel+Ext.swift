//
//  UILabel+Ext.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit

extension UILabel {
    
    func applyNoToSansKR (
        text: String = "Text is Empty",
        style: NotoSansKRStyle = .regular,
        size: CGFloat = 11.0,
        color: UIColor = .black )
    {
        self.text = text
        self.font = font.NoToSansKRStyle(style: style, size: size)
        self.textColor = color
    }
}
