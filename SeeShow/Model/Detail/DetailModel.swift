//
//  DetailModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/06.
//

import Foundation
import SWXMLHash

/// 디테일 모델
/// API response에 사용
struct DetailModel: XMLObjectDeserialization {
    let mt20id: String?         // ID
    let prfnm: String?          // 공연명
    let prfpdfrom: String?      // 공연 기간 시작
    let prfpdto: String?        // 공연 기간 끝
    let fcltynm: String?        //  공연장
    let prfcast: String?        // 배우 목록
    let prfcrew: String?        // 크루 목록
    let prfruntime: String?     // 공연 런타임
    let prfage: String?         // 나이 제한
    let entrpsnm: String?       // 회사
    let pcseguidance: String?   // 가격
    let poster: String?         // 포스터 url
    let sty: String?            // sty
    let genrenm: String?        // 장르
    let prfstate: String?       // 공연중 여부
    let openrun: String?        // 오픈런 여부
    let styurls: [String]?      // 디테일 포스터 urls
    let dtguidance: String?     // 공연 시간
    
    static func deserialize(_ element: XMLIndexer) throws -> DetailModel {
        return try DetailModel(
            mt20id: element["mt20id"].value(),
            prfnm: element["prfnm"].value(),
            prfpdfrom: element["prfpdfrom"].value(),
            prfpdto: element["prfpdto"].value(),
            fcltynm: element["fcltynm"].value(),
            prfcast: element["prfcast"].value(),
            prfcrew: element["prfcrew"].value(),
            prfruntime: element["prfruntime"].value(),
            prfage: element["prfage"].value(),
            entrpsnm: element["entrpsnm"].value(),
            pcseguidance: element["pcseguidance"].value(),
            poster: element["poster"].value(),
            sty: element["sty"].value(),
            genrenm: element["genrenm"].value(),
            prfstate: element["prfstate"].value(),
            openrun: element["openrun"].value(),
            styurls: element["styurls"]["styurl"].value(),
            dtguidance: element["dtguidance"].value()
        )
    }
}
