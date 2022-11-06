//
//  MainViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import SWXMLHash
import RxDataSources

protocol MainViewModelType {
    // INPUT
    var fetchBoxOffices: AnyObserver<Void> { get }
    var fetchKidsBoxOffices: AnyObserver<Void> { get }
    
    // OUTPUT
    var allBoxOffices: Observable<[ViewBoxOffice]> { get }
    var pushKidsBoxOffices: Observable<[ViewBoxOffice]> { get }
    var activated: Observable<Bool> { get }
    
}

class MainViewModel: MainViewModelType {
    let disposeBag = DisposeBag()

    // INPUT
    let fetchBoxOffices: AnyObserver<Void>
    let fetchKidsBoxOffices: AnyObserver<Void>
    
    // OUTPUT
    let allBoxOffices: Observable<[ViewBoxOffice]>
    let pushKidsBoxOffices: Observable<[ViewBoxOffice]> // 이게 받아줘야 하는데 이름이 같아서 오류
    let activated: Observable<Bool> // Indicator, SkeletonView 동작
    
    init(domain: BoxOfficeFetchable = BoxOfficeStore()) {
        print("HomeViewModel init")

        let fetching = PublishSubject<Void>()
        let fetchingKids = PublishSubject<Void>()
        
        let activating = BehaviorSubject<Bool>(value: false)
        
        
        let defaultViewBoxOffice: [ViewBoxOffice] = [
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "https://user-images.githubusercontent.com/108163842/193484428-78bd3fb2-3502-43f0-8787-3420c4aff26a.png", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "https://user-images.githubusercontent.com/108163842/193484428-78bd3fb2-3502-43f0-8787-3420c4aff26a.png", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "https://user-images.githubusercontent.com/108163842/193484428-78bd3fb2-3502-43f0-8787-3420c4aff26a.png", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "https://user-images.githubusercontent.com/108163842/193484428-78bd3fb2-3502-43f0-8787-3420c4aff26a.png", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "https://user-images.githubusercontent.com/108163842/193484428-78bd3fb2-3502-43f0-8787-3420c4aff26a.png", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
        ]
        
        let boxoffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        let kidsBoxOffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        
        
        // INPUT
        //
        fetchBoxOffices = fetching.asObserver() // fetcing 과 FetchboxOffice를 연결
        fetchKidsBoxOffices = fetchingKids.asObserver()
        
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchBoxOffices) // -> [BoxOfficeModel]
            .map { $0.map { ViewBoxOffice($0) } } // -> [ViewBoxOffice]
            .subscribe(onNext: boxoffices.onNext) // boxoffice의 onNext로 전달
            .disposed(by: disposeBag)
        
        fetchingKids
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchKidsBoxOffice)
            .map { $0.map { ViewBoxOffice($0) }}
            .subscribe(onNext: kidsBoxOffices.onNext)
            .disposed(by: disposeBag)
        
        // OUTPUT
        //
        allBoxOffices = boxoffices
        pushKidsBoxOffices = kidsBoxOffices
        
        // allBoxOffices랑 pushKidsBoxOffice를 묶었다.
        let ziptest = Observable.zip(allBoxOffices, pushKidsBoxOffices)
        _ = ziptest
            .skip(1)
            .do(onNext: { _ in activating.onNext(false) })
            .subscribe(onNext: { values in
            //print(values)
            }).disposed(by: disposeBag)
                
        activated = activating.distinctUntilChanged() // distinctUntilChanged = 연달아서 중복된 값이 올 경우 무시
      
    }
    
}
