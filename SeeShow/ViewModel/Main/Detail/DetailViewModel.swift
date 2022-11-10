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
import Kingfisher

protocol DetailViewModelType {
    // INPUT
    //var prfrID: String { get set }
    var fetchDetails: AnyObserver<Void> { get }
    
    // OUTPUT
    var pushDetails: Observable<ViewDetail> { get }
    var activated: Observable<Bool> { get }
    var errorMessage: Observable<NSError> { get }
    
    // OUTPUT (UI)
    /// 공연명
    var prfnmText: Observable<String> { get }
    ///공연 기간
    var prfpdFromToText: Observable<String> { get }
    /// 공연장
    var fcltynmText: Observable<String> { get }
    /// 공연 런타임
    var prfruntimeText: Observable<String> { get }
    /// 공연 관람 연령
    var prfageText: Observable<String> { get }
    /// 공연 시간
    var dtguidanceText: Observable<String> { get }
//    /// 공연 가격
//    var pcseguidanceText: Observable<String> { get }
    /// 포스터
    //var posterImage: Observable<UIImage> { get }
//    /// 장르
//    var gerenmText: Observable<String> { get }
//    /// 공연 상태
//    var prfstateText: Observable<String> { get }
    /// [공연 소개 이미지]
    //var styImageArray: Observable<[KFCrossPlatformImage]> { get }
}

class DetailViewModel: DetailViewModelType {
    
    let disposeBag = DisposeBag()
    
    // INPUT
    let fetchDetails: AnyObserver<Void>
    
    // OUTPUT
    let pushDetails: Observable<ViewDetail>
    let activated: Observable<Bool>
    let errorMessage: Observable<NSError>
    
    /// 공연명
    let prfnmText: Observable<String>
    /// 공연 기간
    let prfpdFromToText: Observable<String>
    /// 공연장
    let fcltynmText: Observable<String>
    /// 공연 런타임
    let prfruntimeText: Observable<String>
    /// 공연 관람 연령
    let prfageText: Observable<String>
    /// 공연 시간
    let dtguidanceText: Observable<String>
//    /// 공연 가격
//    let pcseguidanceText: Observable<String>
    /// 포스터
    //let posterImage: Observable<UIImage>
//    /// 장르
//    let gerenmText: Observable<String>
//    /// 공연 상태
//    let prfstateText: Observable<String>
    /// [공연 소개 이미지]
    //let styImageArray: Observable<[KFCrossPlatformImage]>
    
    
    init(domain: DetailFetchable = DetailStore(id: String())) {
        print("DetailViewModel init()")
        
        let fetching = PublishSubject<Void>()
        
        let activating = BehaviorSubject<Bool>(value: false)
        
        let details = BehaviorSubject<ViewDetail>(value: ViewDetail(DetailModel(mt20id: "Empty", prfnm: "Empty", prfpdfrom: "Empty", prfpdto: "Empty", fcltynm: "Empty", prfcast: "Empty", prfcrew: "Empty", prfruntime: "Empty", prfage: "Empty", entrpsnm: "Empty", pcseguidance: "Empty", poster: "", sty: "Empty", genrenm: "Empty", prfstate: "Empty", openrun: "Empty", styurls: [], dtguidance: "Empty")))
        
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
                
        //UI
        prfnmText = details.map({ detail in
            detail.prfnm
        })
                
        prfpdFromToText = details.map({ detail in
            detail.prfpdfrom + "~" + detail.prfpdto
        })
                
        fcltynmText = details.map{ $0.fcltynm }
        prfageText = details.map{ $0.prfage }
        prfruntimeText = details.map { $0.prfruntime }
        dtguidanceText = details.map { $0.dtguidance }
        
        
        #warning("TODO : - ErrorMessage 추가하자. MainViewController도.. ")
        errorMessage = error.map { $0 as NSError }
    }
    
}
