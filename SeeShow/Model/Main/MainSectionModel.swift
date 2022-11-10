//
//  SectionModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/02.
//

import Foundation
import Differentiator
import RxSwift


///
/// DataSource에 사용될 SecionModel
enum MainSectionModel {
    case BannerSection(title: String, items: [SectionItem])
    case CategorySection(title: String, items: [SectionItem])
    case TheaterSection(title: String, items: [SectionItem])
    case UNISection(title: String, items: [SectionItem])
    case OpenRunSection(title: String, items: [SectionItem])
    case KidsSection(title: String, items: [SectionItem])
}
enum SectionItem {
    case BannerSectionItem(Observable<ViewBoxOffice>)
    case CategorySectionItem(image: UIImage, title: String)
    case TheaterSectionItem(Observable<ViewBoxOffice>)
    case UNISectionItem(Observable<ViewBoxOffice>)
    case OpenRunSectionItem(Observable<ViewBoxOffice>)
    case KidsSectionItem(Observable<ViewBoxOffice>)
}

extension MainSectionModel: SectionModelType {
    typealias Item = SectionItem
    
    var items: [SectionItem] {
        switch self {
        case .BannerSection(title: _, items: let items):
            return items.map{ $0 }
        case .CategorySection(title: _, items: let items):
            return items.map{ $0 }
        case .TheaterSection(title: _, items: let items):
            return items.map { $0 }
        case .UNISection(title: _, items: let items):
            return items.map { $0 }
        case .OpenRunSection(title: _, items: let items):
            return items.map { $0 }
        case .KidsSection(title: _, items: let items):
            return items.map { $0 }
        }
    }
    
    init(original: MainSectionModel, items: [SectionItem]) {
        switch original {
        case let .BannerSection(title: title, items: _):
            self = .BannerSection(title: title, items: items)
            
        case let .CategorySection(title: title, items: _):
            self = .CategorySection(title: title, items: items)
            
        case let .TheaterSection(title: title, items: _):
            self = .TheaterSection(title: title, items: items)
            
        case let .UNISection(title: title, items: _):
            self = .UNISection(title: title, items: items)
            
        case let .OpenRunSection(title: title, items: _):
            self = .OpenRunSection(title: title, items: items)
            
        case let .KidsSection(title: title, items: _):
            self = .KidsSection(title: title, items: items)
        }
    }
}

extension MainSectionModel {
    var title: String {
        switch self {
        case .BannerSection(title: let title, items: _):
            return title
        case .CategorySection(title: let title, items: _):
            return title
        case .TheaterSection(title: let title, items: _):
            return title
        case .UNISection(title: let title, items: _):
            return title
        case .OpenRunSection(title: let title, items: _):
            return title
        case .KidsSection(title: let title, items: _):
            return title
        }
    }
}
