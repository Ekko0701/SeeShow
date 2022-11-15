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
    func fetchKidsBoxOffice() -> Observable<[BoxOfficeModel]>
    func fetchTheaterBoxOffice() -> Observable<[BoxOfficeModel]>
    func fetchUNIBoxOffice() -> Observable<[BoxOfficeModel]>
    func fetchOpenRunBoxOffice() -> Observable<[BoxOfficeModel]>
}

class BoxOfficeStore: BoxOfficeFetchable {
    /// fetchAllBoxOffice를 통해 받아온 XML 데이터를 BoxOfficeModel로 파싱하고 Observable로 만들어 반환.
    
    func fetchBoxOffices() -> Observable<[BoxOfficeModel]> {
        /// box office model = api에서 받아온 그대로를 파싱한것
        return KopisAPIService.fetchAllBoxOffice()
            .map { data -> [BoxOfficeModel] in
                //let xml = XMLHash.parse(data)
                let xml = XMLHash.parse(data)
                do {
                    let parsedData: [BoxOfficeModel] = try xml["boxofs"]["boxof"].value()
                    
                    let min = min(parsedData.count, 10)
                    let sliceData = parsedData[0..<min] // 최대 10개로 제한
                    
                    return Array(sliceData)
                }
            }
    }
    
    func fetchKidsBoxOffice() -> Observable<[BoxOfficeModel]> {
        
        return KopisAPIService.fetchKidsBoxOffice()
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
    
    func fetchTheaterBoxOffice() -> Observable<[BoxOfficeModel]> {
        
        return KopisAPIService.fetchTheaterBoxOffice()
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
    
    func fetchUNIBoxOffice() -> Observable<[BoxOfficeModel]> {
        
        return KopisAPIService.fetchUNIBoxOffice()
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
    
    func fetchOpenRunBoxOffice() -> Observable<[BoxOfficeModel]> {
        
        return KopisAPIService.fetchOpenRunBoxOffice()
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
