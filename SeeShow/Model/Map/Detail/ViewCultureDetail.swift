//
//  ViewCultureDetail.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/01.
//

import Foundation

struct ViewCultureDetail {
    var title: String
    var period: String
    var place: String
    var realmName: String
    var imageURL: String
    var placeAddr: String
    
    init(_ item: CultureDetailModel) {
        title = item.title ?? "공연명 정보 없음"
        period = (item.startDate ?? "공연 시작일 정보 없음") + "~" + (item.endDate ?? "공연 마감일 정보 없음")
        place = item.place ?? "공연장 정보 없음"
        realmName = item.realmName ?? "분류 정보 없음"
        imageURL = item.imgUrl ?? "포스터 정보 없음"
        placeAddr = item.placeAddr ?? "공연장 주소 정보 없음"
    }
}
