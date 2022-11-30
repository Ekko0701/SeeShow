//
//  KopisAPICommonCode.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/09.
//

import Foundation

/// AAAA : 연극
/// AAAB : 뮤지컬
/// BBBA : 무용
/// CCCA : 클래식
/// CCCB : 오페라
/// CCCC : 국악
/// EEEA : 복합
enum CateCode {
    case ALL, AAAA, AAAB, BBBA, CCCA, CCCB, CCCC, EEEA, KID, OPEN
}

extension CateCode {
    func cateCodeToString() -> String {
        switch self {
        case .ALL:
            return ""
        case .AAAA:
            return "AAAA"
        case .AAAB:
            return "AAAB"
        case .BBBA:
            return "BBBA"
        case .CCCA:
            return "CCCA"
        case .CCCB:
            return "CCCB"
        case .CCCC:
            return "CCCC"
        case .EEEA:
            return "EEEA"
        case .KID:
            return "KID"
        case .OPEN:
            return "OPEN"
        }
    }
}
