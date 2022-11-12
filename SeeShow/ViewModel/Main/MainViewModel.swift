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
    var fetchTheaterBoxOffices: AnyObserver<Void> { get }
    var fetchUNIBoxOffices: AnyObserver<Void> { get }
    var fetchOpenRunBoxOffices: AnyObserver<Void> { get }
    var fetchKidsBoxOffices: AnyObserver<Void> { get }
    
    var touchCell: PublishSubject<IndexPath> { get }
    
    // OUTPUT
    var allBoxOffices: Observable<[ViewBoxOffice]> { get }
    var pushKidsBoxOffices: Observable<[ViewBoxOffice]> { get }
    
    var section: [MainSectionModel] { get }
    
    var activated: Observable<Bool> { get }
    var showDetailPage: Observable<String> { get }
    
}

class MainViewModel: MainViewModelType {
    
    
    let disposeBag = DisposeBag()

    // ----------------------------
    // INPUT
    //----------------------------

    let fetchBoxOffices: AnyObserver<Void>
    let fetchTheaterBoxOffices: AnyObserver<Void>
    let fetchUNIBoxOffices: AnyObserver<Void>
    let fetchOpenRunBoxOffices: AnyObserver<Void>
    let fetchKidsBoxOffices: AnyObserver<Void>
    
    var touchCell: PublishSubject<IndexPath>
    
    //----------------------------
    // OUTPUT
    //----------------------------

    let allBoxOffices: Observable<[ViewBoxOffice]>
    let pushTheaterBoxOffices: Observable<[ViewBoxOffice]>
    let pushUNIBoxOffices: Observable<[ViewBoxOffice]>
    let pushOpenRunBoxOffices: Observable<[ViewBoxOffice]>
    let pushKidsBoxOffices: Observable<[ViewBoxOffice]>
    
    let section: [MainSectionModel]
    
    let activated: Observable<Bool> // Indicator, SkeletonView 동작
    
    let showDetailPage: Observable<String> // ID 전달할거야
    
    
    init(domain: BoxOfficeFetchable = BoxOfficeStore()) {

        // API Request
        let fetching = PublishSubject<Void>()
        let fetchingTheathers = PublishSubject<Void>()
        let fetchingUNI = PublishSubject<Void>()
        let fetchingOpenRun = PublishSubject<Void>()
        let fetchingKids = PublishSubject<Void>()
        
        // Cell Event
        let cellTouching = PublishSubject<IndexPath>()
        
        let activating = BehaviorSubject<Bool>(value: false)
        
        let defaultViewBoxOffice: [ViewBoxOffice] = [
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
            ViewBoxOffice(BoxOfficeModel(area: "Empty", prfdtcnt: 0, prfpd: "Empty", cate: "Empty", prfplcnm: "Empty", prfnm: "Empty", rnum: 0, seatcnt: 0, poster: "Empty", mt20id: "Empty")),
        ]
        
        let boxoffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        let theaterBoxOffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        let uniBoxOffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        let openrunBoxOffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        let kidsBoxOffices = BehaviorSubject<[ViewBoxOffice]>(value: defaultViewBoxOffice)
        
        // INPUT
        //
        fetchBoxOffices = fetching.asObserver() // fetcing 과 FetchboxOffice를 연결
        fetchTheaterBoxOffices = fetchingTheathers.asObserver()
        fetchUNIBoxOffices = fetchingUNI.asObserver()
        fetchOpenRunBoxOffices = fetchingOpenRun.asObserver()
        fetchKidsBoxOffices = fetchingKids.asObserver()
        
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchBoxOffices) // -> [BoxOfficeModel]
            .map { $0.map { ViewBoxOffice($0) }} // -> [ViewBoxOffice]
            .subscribe(onNext: boxoffices.onNext) // boxoffice의 onNext로 전달
            .disposed(by: disposeBag)
        
        fetchingTheathers
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchTheaterBoxOffice)
            .map{ $0.map { ViewBoxOffice($0) }}
            .subscribe(onNext: theaterBoxOffices.onNext) // Relay는 accept로 이벤트를 보낸다.
            .disposed(by: disposeBag)
        
        fetchingUNI
            .flatMap(domain.fetchUNIBoxOffice)
            .map { $0.map { ViewBoxOffice($0) }}
            .subscribe(onNext: uniBoxOffices.onNext)
            .disposed(by: disposeBag)
        
        fetchingOpenRun
            .flatMap(domain.fetchOpenRunBoxOffice)
            .map { $0.map { ViewBoxOffice($0) }}
            .subscribe(onNext: openrunBoxOffices.onNext)
            .disposed(by: disposeBag)
        
        fetchingKids
            .flatMap(domain.fetchKidsBoxOffice)
            .map { $0.map { ViewBoxOffice($0) }}
            .subscribe(onNext: kidsBoxOffices.onNext)
            .disposed(by: disposeBag)
        
       
        // OUTPUT
        //
        allBoxOffices = boxoffices
        pushTheaterBoxOffices = theaterBoxOffices
        pushUNIBoxOffices = uniBoxOffices
        pushOpenRunBoxOffices = openrunBoxOffices
        pushKidsBoxOffices = kidsBoxOffices
        
        // allBoxOffices랑 pushKidsBoxOffice를 묶었다.
        let ziptest = Observable.zip(allBoxOffices, pushKidsBoxOffices,pushTheaterBoxOffices,pushUNIBoxOffices,pushOpenRunBoxOffices)
        _ = ziptest
            .skip(1)
            .do(onNext: { _ in activating.onNext(false) })
            .subscribe(onNext: { values in
            //print(values)
            }).disposed(by: disposeBag)
                
        activated = activating.distinctUntilChanged() // distinctUntilChanged = 연달아서 중복된 값이 올 경우 무시
        
                
        // Section, SectionItems
        var bannerSectionItemArr: [SectionItem] = [ .BannerSectionItem(allBoxOffices) ]
                
        var theaterSectionItemsArr: [SectionItem] = [.TheaterSectionItem(pushTheaterBoxOffices.map { $0[0] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[1] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[2] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[3] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[4] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[5] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[6] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[7] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[8] }),
                                                     .TheaterSectionItem(pushTheaterBoxOffices.map { $0[9] }),]
                
        var uniSectionItemArr: [SectionItem] = [.UNISectionItem(pushUNIBoxOffices.map { $0[0] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[1] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[2] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[3] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[4] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[5] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[6] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[7] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[8] }),
                                                .UNISectionItem(pushUNIBoxOffices.map { $0[9] }),]
                
        var openrunSectionItemArr: [SectionItem] = [.OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[0] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[1] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[2] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[3] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[4] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[5] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[6] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[7] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[8] }),
                                                    .OpenRunSectionItem(pushOpenRunBoxOffices.map { $0[9] }),]
        
                var kidsSectionItemArr: [SectionItem] = [.KidsSectionItem(pushKidsBoxOffices.map{ $0[0] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[1] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[2] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[3] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[4] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[5] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[6] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[7] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[8] }),
                                                         .KidsSectionItem(pushKidsBoxOffices.map{ $0[9] }),
                
                ]
        section = [
            MainSectionModel.BannerSection(title: "Banner", items: bannerSectionItemArr),
            MainSectionModel.CategorySection(title: "Category", items: [
                .CategorySectionItem(image: UIImage(named: "test1")!, title: "연극"),
                .CategorySectionItem(image: UIImage(named: "test2")!, title: "뮤지컬"),
                .CategorySectionItem(image: UIImage(named: "test3")!, title: "무용"),
                .CategorySectionItem(image: UIImage(named: "test4")!, title: "클래식"),
                .CategorySectionItem(image: UIImage(named: "test5")!, title: "오페라"),
                .CategorySectionItem(image: UIImage(named: "test6")!, title: "국악"),
                .CategorySectionItem(image: UIImage(named: "test7")!, title: "기타"),
                .CategorySectionItem(image: UIImage(named: "test8")!, title: "축제"),
                .CategorySectionItem(image: UIImage(named: "test9")!, title: "공연장"),
                .CategorySectionItem(image: UIImage(named: "test10")!, title: "더보기"),
            ]),
            MainSectionModel.TheaterSection(title: "Theater", items: theaterSectionItemsArr),
            MainSectionModel.TheaterSection(title: "UNI", items: uniSectionItemArr),
            MainSectionModel.TheaterSection(title: "OPEN RUN", items: openrunSectionItemArr),
            MainSectionModel.KidsSection(title: "Kids", items: kidsSectionItemArr),
        ]
        
        touchCell = cellTouching.asObserver()
        
                
        showDetailPage = Observable.combineLatest(cellTouching, boxoffices, pushTheaterBoxOffices, pushUNIBoxOffices, pushOpenRunBoxOffices, pushKidsBoxOffices ,resultSelector: { (indexPath, bannerData , theaterData, uniData, openRunData, kidsData ) in
                    
            switch indexPath.section {
            case 0:
                return bannerData[indexPath.item].mt20id
            case 1:
            #warning("TODO : - Category View로 이동해야함. ")
                return theaterData[indexPath.item].mt20id
            case 2:
                return theaterData[indexPath.item].mt20id
            case 3:
                return uniData[indexPath.item].mt20id
            case 4:
                return openRunData[indexPath.item].mt20id
            case 5:
                return kidsData[indexPath.item].mt20id
            default:
                return String()
            }
        })
                
        }
    
}
