//
//  PageSectionModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/14.
//

import Foundation
import RxDataSources
import Differentiator
import RxSwift

struct PageData {
    var data: Observable<ViewPageData>
}

struct PageSectionModel {
    var title: String
    var items: [Item]
}

extension PageSectionModel: SectionModelType {
    typealias Item = PageData
    
    init(original: PageSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
