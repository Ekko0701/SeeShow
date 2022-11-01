//
//  BoxOfficeModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import SWXMLHash

/// 박스 오피스 모델
/// API response에 사용
struct BoxOfficeModel: XMLObjectDeserialization {
    let area: String?    // 지역
    let prfdtcnt: Int?   // 상연횟수
    let prfpd: String?   // 공연기간
    let cate: String?    //장르
    let prfplcnm: String?// 공연장
    let prfnm: String?   // 공연명
    let rnum: Int?       // 순위
    let seatcnt: Int?    // 좌석수
    let poster: String?  // 포스터 url
    let mt20id: String?  // 아이디
    
    static func deserialize(_ element: XMLIndexer) throws -> BoxOfficeModel {
        return try BoxOfficeModel(
            area: element["area"].value(),
            prfdtcnt: element["prfdtcnt"].value(),
            prfpd: element["prfpd"].value(),
            cate: element["cate"].value(),
            prfplcnm: element["prfplcnm"].value(),
            prfnm: element["prfnm"].value(),
            rnum: element["rnum"].value(),
            seatcnt: element["seatcnt"].value(),
            poster: element["poster"].value(),
            mt20id: element["mt20id"].value()
        )
    }
}
