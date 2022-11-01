//
//  BannerSectionModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation

struct BoxOffice {
    var prfnm: String   // 공연명
    var rnum: Int       // 순위
    var poster: String  // 포스터 url
    var mt20id: String  // 아이디
}

struct BannerSection {
    var header: String
    var items: [BoxOfficeModel]
    
    init(header: String, items: [BoxOfficeModel]) {
        self.header = header
        self.items = items
    }
}

extension BannerSection: SectionModelType {
    init(original: BannerSection, items: [BoxOfficeModel]) {
        self = original
        self.items = items
    }
    
    
}

public protocol SectionModelType {
    associatedtype Item
    
    var items: [Item] { get }
    
    init(original: Self, items: [Item])
}
