//
//  ViewBoxOffice.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation

/// ViewModel
/// HomeViewModel에서 allBoxOffice 옵저버를 통해 HomewViewController로 OutPut할 데이터 구조
///

struct ViewBoxOffice {
    var prfnm: String   // 공연명
    var rnum: Int       // 순위
    var poster: String  // 포스터 url
    var mt20id: String  // 아이디
    
    init(_ item: BoxOfficeModel) {
        prfnm = item.prfnm ?? "공연명 정보 없음"
        rnum = item.rnum ?? 0
        poster = item.poster ?? "포스터 url 없음"
        mt20id = item.mt20id ?? "공연 Id 없음"
    }
}


