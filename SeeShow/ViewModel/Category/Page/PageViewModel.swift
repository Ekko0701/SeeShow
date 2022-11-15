//
//  PageViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/15.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import RxDataSources

protocol PageViewModelType {
    // INPUT
    var fetchBoxOffices: AnyObserver<Void> { get }
    
    // OUTPUT
    var pushBoxOffices: PublishRelay<[ViewPageData]> { get }
    
    var activated: Observable<Bool> { get }
    
    var dataSource: RxTableViewSectionedReloadDataSource<PageSectionModel> { get }
    var pushSection: PublishRelay<[PageSectionModel]> { get }
}

class PageViewModel: PageViewModelType {
    
    
    let disposeBag = DisposeBag()
    
    // ---------------------------
    // INPUT
    //----------------------------
    let fetchBoxOffices: AnyObserver<Void>
    
    //----------------------------
    // OUTPUT
    //----------------------------
    let pushBoxOffices: PublishRelay<[ViewPageData]>
    let activated: Observable<Bool>
    let dataSource: RxTableViewSectionedReloadDataSource<PageSectionModel>
    var pushSection: PublishRelay<[PageSectionModel]>
    
    init(domain: PageBoxOfficeFetchable = PageBoxOfficeStore(cateCode: .ALL)) {
        let fetching = PublishSubject<Void>()
        let activating = BehaviorSubject<Bool>(value: false)
        let error = PublishSubject<Error>()
        
        let boxoffices = PublishRelay<[ViewPageData]>()
        let fetchingSection = PublishRelay<[PageSectionModel]>()
        
        // INPUT
        //
        fetchBoxOffices = fetching.asObserver()
        
        fetching
            .debug()
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchPageBoxOffice)
            .map { $0.map { ViewPageData($0) }}
            .do(onNext: {data in
                activating.onNext(false)
                // Section
                fetchingSection.accept([PageSectionModel(title: "page", items: data.map({ data in
                    PageData(data: data)
                }))])
            })
            .subscribe(onNext: boxoffices.accept)
            .disposed(by: disposeBag)
        
        // OUTPUT
        pushBoxOffices = boxoffices
        pushSection = fetchingSection
        
        activated = activating.distinctUntilChanged()
                
        // DataSource
        dataSource = RxTableViewSectionedReloadDataSource<PageSectionModel>(configureCell: { dataSource, tableView, indexPath, item in
            guard let cell: PageCell = tableView.dequeueReusableCell(withIdentifier: PageCell.identifier, for: indexPath) as? PageCell else { return UITableViewCell() }
            cell.configure(with: item.data)
            return cell
        })
    }
}
