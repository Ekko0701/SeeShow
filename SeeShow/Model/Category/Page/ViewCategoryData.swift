//
//  ViewCategoryData.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/14.
//

import Foundation

/// ViewModel
/// CategoryView의 각 Page에서 보여줄 데이터 모델
struct ViewPageData {
    /// 공연명
    var prfnm: String
    /// 공연장
    var prfplcnm: String
    /// 공연 기간
    var prfpd: String
    /// 포스터 URL
    var poster: String
    /// id
    var mt20id: String
    
    init(_ item: BoxOfficeModel) {
        prfnm = item.prfnm ?? "공연명 정보 없음"
        prfplcnm = item.prfplcnm ?? "공연장 정보 없음"
        prfpd = item.prfpd ?? "공연 기간 정보 없음"
        poster = "http://kopis.or.kr" + (item.poster ?? "포스터 url 없음")
        mt20id = item.mt20id ?? "아이디 정보 없음"
    }
}
