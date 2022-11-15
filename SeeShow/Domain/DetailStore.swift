//
//  DetailFetchable.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/07.
//

import Foundation
import RxSwift
import SWXMLHash

protocol DetailFetchable {
    var id: String { get set }
    func fetchDetail() -> Observable<DetailModel>
}

class DetailStore: DetailFetchable {
    // 클래스 자체에서 id를 선언해주고
    // id를 class 내부 변수로 사용해주자.
    
    var id: String = ""
    
    init(id: String) {
        self.id = id
    }
    /// XML 데이터 -> DetailModel (Observable(
    func fetchDetail() -> Observable<DetailModel> {
        print("fetchDetail()")
        
        return KopisAPIService.fetchPrfrDetail(id: id).map { data -> DetailModel in
            let xml = XMLHash.parse(data)
            do {
                let parsedData: DetailModel = try xml["dbs"]["db"].value()
                print("DetailStore - fetchDetail() \(parsedData)")
                
                return parsedData
            }
        }
    }
}
