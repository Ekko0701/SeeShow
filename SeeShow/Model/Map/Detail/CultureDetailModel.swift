//
//  CultureDetailModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/01.
//

import Foundation
import SWXMLHash

struct CultureDetailResponseModel: XMLObjectDeserialization {
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

struct CultureDetailModel: XMLObjectDeserialization {
    /// 공연 제목
    let title: String?
    /// 공연 시작일
    let startDate: String?
    /// 공연 종료일
    let endDate: String?
    /// 공연 장소
    let place: String?
    /// 공연 분류
    let realmName: String?
    /// 공연 예매 url
    let url: String?
    /// 연락 정보
    let phone: String?
    /// 썸네일 이미지 url
    let imgUrl: String?
    /// 공연 장소 url
    let placeUrl: String?
    /// 공연 장소 주소
    let placeAddr: String?
    
    static func deserialize(_ element: XMLIndexer) throws -> CultureDetailModel {
        return try CultureDetailModel(
            title: element["title"].value(),
            startDate: element["startDate"].value(),
            endDate: element["endDate"].value(),
            place: element["place"].value(),
            realmName: element["realmName"].value(),
            url: element["url"].value(),
            phone: element["phone"].value(),
            imgUrl: element["imgUrl"].value(),
            placeUrl: element["placeUrl"].value(),
            placeAddr: element["placeAddr"].value())
    }
}
