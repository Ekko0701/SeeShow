//
//  CategoryViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/15.
//

import Foundation
import RxSwift

protocol CategoryViewModelType {
    //OUTPUT
    var categories: [CategoryModel] { get }
    var pageViewControllers: [UIViewController] { get }
}

class CategoryViewModel: CategoryViewModelType {
    
    
    let disposeBag = DisposeBag()
    
    // OUTPUT
    let categories: [CategoryModel]
    let pageViewControllers: [UIViewController]
    
    // Initialize
    init() {
        categories = [
            CategoryModel(title: "전체"),
            CategoryModel(title: "연극"),
            CategoryModel(title: "뮤지컬"),
            CategoryModel(title: "클래식"),
            CategoryModel(title: "오페라"),
            CategoryModel(title: "무용"),
            CategoryModel(title: "국악"),
            CategoryModel(title: "복합"),
            CategoryModel(title: "아동"),
            CategoryModel(title: "오픈런")
        ]
        
        pageViewControllers = [
            AllPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .ALL))),
            TheaterPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .AAAA))),
            MusicalPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .AAAB))),
            ClassicPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .CCCA))),
            OperaPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .CCCB))),
            DancePageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .BBBA))),
            KoreanMusicPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .CCCC))),
            ComplexityPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .EEEA))),
            KidsPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .KID))),
            OpenRunPageViewController(viewModel: PageViewModel(domain: PageBoxOfficeStore(cateCode: .OPEN)))
        ]
    }
    
}
