//
//  LocationShowModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/24.
//

import Foundation
import SWXMLHash

/**
 Culture.go.kr에서 받아온 지역 기반 공연 목록 '응답' 모델
 **/
struct CutureResponseModel: XMLObjectDeserialization {
    /// 응답 성공 여부
    let successYN: String?
    /// 에러 코드
    let returnCode: Int?
    /// 에러 메시지
    let errMsg: String?
    
    static func deserialize(_ element: XMLIndexer) throws -> CutureResponseModel {
        return try CutureResponseModel(
            successYN: element["SuccessYN"].value(),
            returnCode: element["ReturnCode"].value(),
            errMsg: element["ErrMsg"].value()
        )
    }
}

/**
 Culture.go.kr에서 받아온 지역 기반 공연 목록 모델
 **/
struct CultureModel: XMLObjectDeserialization {
    let seq: String?
    let title: String?
    let startDate: String?
    let endDate: String?
    let place: String?
    let realmName: String?
    let area: String?
    let thumbnail: String?
    let gpsX: String?
    let gpsY: String?
    
    static func deserialize(_ element: XMLIndexer) throws -> CultureModel {
        return try CultureModel(
            seq: element["seq"].value(),
            title: element["title"].value(),
            startDate: element["startDate"].value(),
            endDate: element["endDate"].value(),
            place: element["place"].value(),
            realmName: element["realmName"].value(),
            area: element["area"].value(),
            thumbnail: element["thumbnail"].value(),
            gpsX: element["gpsX"].value(),
            gpsY: element["gpsY"].value())
    }
    
}
