//
//  ViewDetail.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/06.
//

import Foundation

/// DetailViewModel에서 pushDetail 옵저버를 통해 DetailViewController로 보내줄 데이터 모델

struct ViewDetail {
    /// 공연명
    var prfnm: String
    /// 공연 시작일
    var prfpdfrom: String
    /// 공연 마감일
    var prfpdto: String
    ///  공연장
    var fcltynm: String     
    /// 공연 런타임
    var prfruntime: String
    /// 공연 관람 연령
    var prfage: String
    /// 공연 가격
    var pcseguidance: String
    /// 포스터 url
    var poster: String
    /// 장르
    var genrenm: String
    /// 공연상태
    var prfstate: String
    /// [공연 소개 이미지 url]
    var styurls: [String]
    /// 공연 시간
    var dtguidance: String
    
    
    init(_ item: DetailModel) {
        prfnm = item.prfnm ?? "공연명 정보 없음"
        prfpdfrom = item.prfpdfrom ?? "공연 기간 정보 없음"
        prfpdto = item.prfpdto ?? "공연 기간 정보 없음"
        fcltynm = item.fcltynm ?? "공연장 정보 없음"
        prfruntime = item.prfruntime ?? "런타임 정보 없음"
        prfage = item.prfage ?? "나이 제한 정보 없음"
        pcseguidance = item.pcseguidance ?? "가격 정보 없음"
        poster = item.poster ?? "포스터 정보 없음"
        genrenm = item.genrenm ?? "공연 기간 정보 없음"
        prfstate = item.prfstate ?? "공연중 정보 없음"
        styurls = item.styurls ?? ["상세 포스터 정보 없음"]
        dtguidance = item.dtguidance ?? "공연 시간 정보 없음"
    }
}
