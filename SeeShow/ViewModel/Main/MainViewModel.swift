//
//  MainViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
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
    
    let dataSource: Observable<RxCollectionViewSectionedReloadDataSource<MainSectionModel>> // collectionView의 dataSource 반환
    //var pushAllBoxOfficesData: [ViewBoxOffice]
    //var pushKidsBoxOfficesData: [ViewBoxOffice]
    
    init(domain: BoxOfficeFetchable = BoxOfficeStore()) {
        print("HomeViewModel init")

        let fetching = PublishSubject<Void>()
        let fetchingKids = PublishSubject<Void>()
        
        let activating = BehaviorSubject<Bool>(value: false)
        
        
        // 여기에 기본값을 넣어주면 되려나
        let boxoffices = BehaviorSubject<[ViewBoxOffice]>(value: [ViewBoxOffice(BoxOfficeModel(area: "test", prfdtcnt: 0, prfpd: "test", cate: "test", prfplcnm: "test", prfnm: "test", rnum: 0, seatcnt: 0, poster: "test", mt20id: "test")),ViewBoxOffice(BoxOfficeModel(area: "test", prfdtcnt: 0, prfpd: "test", cate: "test", prfplcnm: "test", prfnm: "에코", rnum: 0, seatcnt: 0, poster: "test", mt20id: "test")),ViewBoxOffice(BoxOfficeModel(area: "test", prfdtcnt: 0, prfpd: "test", cate: "test", prfplcnm: "test", prfnm: "test", rnum: 0, seatcnt: 0, poster: "test", mt20id: "test")),ViewBoxOffice(BoxOfficeModel(area: "test", prfdtcnt: 0, prfpd: "test", cate: "test", prfplcnm: "test", prfnm: "test", rnum: 0, seatcnt: 0, poster: "test", mt20id: "test")),ViewBoxOffice(BoxOfficeModel(area: "test", prfdtcnt: 0, prfpd: "test", cate: "test", prfplcnm: "test", prfnm: "test", rnum: 0, seatcnt: 0, poster: "test", mt20id: "test")),ViewBoxOffice(BoxOfficeModel(area: "test", prfdtcnt: 0, prfpd: "test", cate: "test", prfplcnm: "test", prfnm: "test", rnum: 0, seatcnt: 0, poster: "test", mt20id: "test"))])
        
        let kidsBoxOffices = BehaviorSubject<[ViewBoxOffice]>(value: [])
        
        var allBoxOfficesData: [ViewBoxOffice]
        var kidsBoxOfficesData: [ViewBoxOffice]
        
        // INPUT
        
        fetchBoxOffices = fetching.asObserver() // fetcing 과 FetchboxOffice를 연결
        fetchKidsBoxOffices = fetchingKids.asObserver()
        
        //let zipObservable = Observable.zip(fetching, fetchingKids)
        
        fetching
            //.debug()
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchBoxOffices) // -> [BoxOfficeModel]
            .map { $0.map { ViewBoxOffice($0) } } // -> [ViewBoxOffice]
            .subscribe(onNext: boxoffices.onNext) // boxoffice의 onNext로 전달
            .disposed(by: disposeBag)
        
        fetchingKids
            //.debug()
            .flatMap(domain.fetchBoxOffices)
            .map { $0.map { ViewBoxOffice($0) }}
            .subscribe(onNext: kidsBoxOffices.onNext)
            .disposed(by: disposeBag)
        
        // OUTPUT
        // CollectionView에 뿌려주는데 사용됨
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
                
        let dataSoureTest = PublishSubject<RxCollectionViewSectionedReloadDataSource<MainSectionModel>>()
                
        dataSource = dataSoureTest.asObserver()
                
        activated = activating.distinctUntilChanged() // distinctUntilChanged = 연달아서 중복된 값이 올 경우 무시
         
//        ziptest.subscribe(onNext: { first, second in
//            print("일번 \(first[1])")
//        }).disposed(by: disposeBag)
                
    }
    
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MainSectionModel>(configureCell: {dataSource, collection, indexPath, _ in
            switch dataSource[indexPath] {
            case let .BannerSectionItem(data):
                guard let cell: BannerCell = collection.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else { return UICollectionViewCell() }
                cell.configure(data: data)
                return cell
            case let .CategorySectionItem(image, title):
                guard let cell: CategoryCell = collection.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
                cell.configure(image: image, title: title)
                return cell
            case let .KidsSectionItem(_):
                return UICollectionViewCell()
            }
        })
    }
    
}

/*
 func dataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
     return RxCollectionViewSectionedReloadDataSource<MainSectionModel>(configureCell:{ dataSource, collection, indexPath, _ in
         switch dataSource[indexPath] {
         case let .BannerSectionItem(<#T##[ViewBoxOffice]#>)
         }
     })
 }
 */

/*
         viewModel.allBoxOffices
             .debug()
             .subscribe(onNext: { [weak self] new in
                 self?.bannerData = new
             })
             .disposed(by: disposeBag)
 */
