//
//  CategoryBOStore.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/14.
//

import Foundation
import RxSwift
import SWXMLHash

protocol PageBoxOfficeFetchable {
    var cateCode: CateCode { get set }
    
    func fetchPageBoxOffice() -> Observable<[BoxOfficeModel]>
}

class PageBoxOfficeStore: PageBoxOfficeFetchable {
    //MARK: - 테스트 진행중...
    
    var cateCode: CateCode = .ALL
    
    init(cateCode: CateCode) {
        self.cateCode = cateCode
    }
    
    func fetchPageBoxOffice() -> Observable<[BoxOfficeModel]> {
        return KopisAPIService.fetchPageBoxOffice(cateCode: cateCode)
            .map { data -> [BoxOfficeModel] in
                let xml = XMLHash.parse(data)
                do {
                    let parsedData: [BoxOfficeModel] = try xml["boxofs"]["boxof"].value()

                    return parsedData
                }
            }

    }
    
    
}
