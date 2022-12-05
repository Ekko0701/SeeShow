//
//  BottomSheetViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/01.
//

import Foundation
import RxSwift
import RxRelay

protocol BottomSheetViewModelType {
    // INPUT
    var fetchCultureDetail: AnyObserver<Void> { get }
    
    // OUTPUT
    var activated: Observable<Bool> { get }
    
    var pushDetails: PublishRelay<ViewCultureDetail> { get }
    var title: Observable<String> { get }
    var place: Observable<String> { get }
    var thumbnail: Observable<String> { get }
    var realmName: Observable<String> { get }
    var period: Observable<String> { get }
}

class BottomSheetViewModel: BottomSheetViewModelType {
    
    
    let disposeBag = DisposeBag()
    
    // ---------------------------
    // INPUT
    //----------------------------
    var fetchCultureDetail: RxSwift.AnyObserver<Void>
    
    //----------------------------
    // OUTPUT
    //----------------------------
    var activated: RxSwift.Observable<Bool>
    
    var pushDetails: PublishRelay<ViewCultureDetail>
    
    var title: Observable<String>
    var place: Observable<String>
    var thumbnail: Observable<String>
    var realmName: Observable<String>
    var period: Observable<String>
    
    init(domain: CultureDetailFetchable = CultureDetailStore(seq: String())) {
        let fetching = PublishSubject<Void>()
        let activating = BehaviorSubject<Bool>(value: false)
        let error = PublishSubject<Error>()
        
        let details = PublishRelay<ViewCultureDetail>()
        
        // INPU
        //
        fetchCultureDetail = fetching.asObserver()
        
        fetching
            .debug()
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchDetail)
            .map { ViewCultureDetail($0) }
            .do(onNext: { result in print("아이고 : \(result.title)")})
            .do(onNext: { _ in activating.onNext(false)})
                .do(onError: { err in error.onNext(err) })
                .subscribe(onNext: details.accept)
                .disposed(by: disposeBag)
                
        // OUTPUT
        //
        pushDetails = details
        activated = activating.distinctUntilChanged()
        
        title = details.debug().map { $0.title }
        place = details.map { $0.place }
        thumbnail = details.map { $0.imageURL }
        realmName = details.map { $0.realmName }
        //period = details.map { $0.period }
        
        period = details.map { data in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
            
            if let date = dateFormatter.date(from: data.period) {
               let secondFormatter = DateFormatter()
                secondFormatter.dateFormat = "yyyy년 MM월 dd일"
                return secondFormatter.string(from: date)
            } else {
                return ""
            }
        }
    }
}
