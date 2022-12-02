//
//  CultureDetailStore.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/01.
//

import Foundation
import RxSwift
import SWXMLHash

protocol CultureDetailFetchable {
    var seq: String { get set }
    
    func fetchDetail() -> Observable<CultureDetailModel>
}

class CultureDetailStore: CultureDetailFetchable {
    var seq: String = ""
    
    init(seq: String) {
        self.seq = seq
    }
    
    func fetchDetail() -> Observable<CultureDetailModel> {
        print("fetchDetail()")
        print("\(seq)")
        return CultureAPIService.fetchCultureDetail(seq: seq).map { data -> CultureDetailModel in
            print("return")
            let xml = XMLHash.parse(data)
            do {
                let parsedData: CultureDetailModel = try xml["response"]["msgBody"]["perforInfo"].value()
                print(parsedData)
                return parsedData
            }
        }
    }
}
