//
//  CALayer+Ext.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/22.
//

import Foundation
import UIKit

extension CALayer {
    
    /// Apply Shadow to Layer
    /// - Parameters:
    ///   - color: 그림자 색상
    ///   - alpha: 그림자 투명도
    ///   - x: 가로 위치
    ///   - y: 세로 위치
    ///   - blur: 블러
    ///   - spread: 퍼짐 정도
    func applyShadow(
        color: UIColor,
        alpha: Float,
        x: CGFloat,
        y: CGFloat,
        blur: CGFloat,
        spread: CGFloat
    ) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let rect = bounds.insetBy(dx: -spread, dy: -spread)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
    
    /// Border 적용
    /// 
    func applyBorder(
        width: CGFloat = 0.78,
        color: UIColor,
        radius: CGFloat?
    ) {
        borderWidth = width
        borderColor = color.cgColor
        if let radius = radius {
            cornerRadius = radius
        }
    }
    
    func clearBorderColor() {
        borderColor = UIColor.clear.cgColor
    }
    
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
            for edge in arr_edge {
                let border = CALayer()
                switch edge {
                case UIRectEdge.top:
                    border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                    break
                case UIRectEdge.bottom:
                    border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                    break
                case UIRectEdge.left:
                    border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                    break
                case UIRectEdge.right:
                    border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                    break
                default:
                    break
                }
                border.backgroundColor = color.cgColor;
                self.addSublayer(border)
            }
        }
}
