//
//  CategoryBOStore.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/14.
//

import Foundation
import RxSwift
import SWXMLHash

protocol CategoryBoxOfficeFetchable {
    var cateCode: CateCode { get set }
    
    func fetchCateCodeBoxOffice() -> Observable<[BoxOfficeModel]>
}

class CategoryBOStore: CategoryBoxOfficeFetchable {
    //MARK: - 테스트 진행중...
    
    var cateCode: CateCode = .ALL
    
    init(cateCode: CateCode) {
        self.cateCode = cateCode
    }
    
    func fetchCateCodeBoxOffice() -> Observable<[BoxOfficeModel]> {
        return KopisAPIService.fetchBoxOfficeWithCateCode(cateCode: cateCode)
            .map { data -> [BoxOfficeModel] in
                let xml = XMLHash.parse(data)
                do {
                    let parsedData: [BoxOfficeModel] = try xml["boxofs"]["boxof"].value()

                    let min = min(parsedData.count, 10)
                    let sliceData = parsedData[0..<min] // 최대 10개로 제한

                    return Array(sliceData)
                }
            }

    }
    
    
}
