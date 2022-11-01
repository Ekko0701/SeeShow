//
//  BoxOfficeStore.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import RxSwift
import SWXMLHash

protocol BoxOfficeFetchable {
    func fetchBoxOffices() -> Observable<[BoxOfficeModel]>
}

class BoxOfficeStore: BoxOfficeFetchable {
    /// fetchAllBoxOffice를 통해 받아온 XML 데이터를 BoxOfficeModel로 파싱하고 Observable로 만들어 반환.
    
    func fetchBoxOffices() -> Observable<[BoxOfficeModel]> {
        print("fetchBoxOffices")
        /// box office model = api에서 받아온 그대로를 파싱한것
        return KopisAPIService.fetchAllBoxOffice()
            .map { data -> [BoxOfficeModel] in
                let xml = XMLHash.parse(data)
                do {
                    let parsedData: [BoxOfficeModel] = try xml["boxofs"]["boxof"].value()
                    print("BoxOfficeStore - fetchBoxOffices()")
                    return parsedData
                }
            }
    }
}
