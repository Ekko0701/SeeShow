//
//  DetailViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import SWXMLHash
import RxDataSources

protocol DetailViewModelType {
    // INPUT
    //var prfrID: String { get set }
    var fetchDetails: AnyObserver<Void> { get }
    
    // OUTPUT
    var pushDetails: Observable<ViewDetail> { get }
    var activated: Observable<Bool> { get }
    var errorMessage: Observable<NSError> { get }
    
//    // OUTPUT (UI)
//    /// 공연명
//    var prfnmText: Observable<String> { get }
//    /// 공연 시작일
//    var prfpdfromText: Observable<String> { get }
//    /// 공연 마감일
//    var prfpdtoText: Observable<String> { get }
//    /// 공연장
//    var fcltynmText: Observable<String> { get }
//    /// 공연 런타임
//    var prfruntimeText: Observable<String> { get }
//    /// 공연 관람 연령
//    var prfageText: Observable<String> { get }
//    /// 공연 가격
//    var pcseguidanceText: Observable<String> { get }
//    /// 포스터
//    var posterImage: Observable<UIImage> { get }
//    /// 장르
//    var gerenmText: Observable<String> { get }
//    /// 공연 상태
//    var prfstateText: Observable<String> { get }
//    /// [공연 소개 이미지]
//    var styImageArray: Observable<[UIImage]> { get }
}

class DetailViewModel: DetailViewModelType {
    #warning("TODO : - 다음 변수 삭제 ")
    static var prfrID: String  = ""
    
    let disposeBag = DisposeBag()
    
    // INPUT
    let fetchDetails: AnyObserver<Void>
    
    // OUTPUT
    let pushDetails: Observable<ViewDetail>
    let activated: Observable<Bool>
    let errorMessage: Observable<NSError>
    
//    /// 공연명
//    let prfnmText: Observable<String>
//    /// 공연 시작일
//    let prfpdfromText: Observable<String>
//    /// 공연 마감일
//    let prfpdtoText: Observable<String>
//    /// 공연장
//    let fcltynmText: Observable<String>
//    /// 공연 런타임
//    let prfruntimeText: Observable<String>
//    /// 공연 관람 연령
//    let prfageText: Observable<String>
//    /// 공연 가격
//    let pcseguidanceText: Observable<String>
//    /// 포스터
//    let posterImage: Observable<UIImage>
//    /// 장르
//    let gerenmText: Observable<String>
//    /// 공연 상태
//    let prfstateText: Observable<String>
//    /// [공연 소개 이미지]
//    let styImageArray: Observable<[UIImage]>
    
    
    init(domain: DetailFetchable = DetailStore(id: prfrID)) {
        print("DetailViewModel init()")
        
        let fetching = PublishSubject<Void>()
        
        let activating = BehaviorSubject<Bool>(value: false)
        
        // -----------
        #warning("TODO : - detailVC에서 기본값으로 설정한 poster url이 한 번 실행된다. Placeholder image url을 추가하던지, skip(1)을 처리해주자.")
        let details = BehaviorSubject<ViewDetail>(value: ViewDetail(DetailModel(mt20id: "test", prfnm: "test", prfpdfrom: "test", prfpdto: "test", fcltynm: "test", prfcast: "test", prfcrew: "test", prfruntime: "test", prfage: "test", entrpsnm: "test", pcseguidance: "test", poster: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF198309_220919_094321.gif", sty: "test", genrenm: "test", prfstate: "test", openrun: "test", styurls: ["test"], dtguidance: "test")))
        
        let error = PublishSubject<Error>()
        
        // INPUT
        //
        fetchDetails = fetching.asObserver() // fetching의 oberver를 fetchDetails와 연결
        
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchDetail)
            .map { ViewDetail($0) }
            .do(onNext: { _ in activating.onNext(false)})
            .do(onError: { err in error.onNext(err) })
            .subscribe(onNext: details.onNext)
            .disposed(by: disposeBag)

        // OUTPUT
        //
        pushDetails = details
        
        activated = activating.distinctUntilChanged()
                
        errorMessage = error.map { $0 as NSError }
        
    }
    
}
