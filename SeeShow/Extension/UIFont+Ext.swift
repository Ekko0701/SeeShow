//
//  UIFont.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit

///**Noto Sans KR 스타일 **
/// NotoSansKR-Regular
/// NotoSansKR-Thin
/// NotoSansKR-Light
/// NotoSansKR-Medium
/// NotoSansKR-Bold
/// NotoSansKR-Black
enum NotoSansKRStyle {
    case regular, thin, light, medium, bold, black
}

extension UIFont {
    
    /// Noto Sans KR 폰트 설정
    /// - Parameters:
    ///   - style: 폰트 스타일
    ///   - size: 폰트 크기
    func NoToSansKRStyle(style: NotoSansKRStyle = .regular, size: CGFloat = 11) -> UIFont {
        var font = ""
        
        switch style {
        case .regular:
            font = "NotoSansKR-Regular"
        case .thin:
            font = "NotoSansKR-Thin"
        case .light:
            font = "NotoSansKR-Light"
        case .medium:
            font = "NotoSansKR-Medium"
        case .bold:
            font = "NotoSansKR-Bold"
        case .black:
            font = "NotoSansKR-Black"
        }
        
        return UIFont(name: font, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
