//
//  MainViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxViewController
import RxDataSources

class MainViewController: UIViewController {
    
    var collectionView: UICollectionView!
    var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.alpha = 0.9
        
        return view
    }()
    
    let disposeBag = DisposeBag()
    let viewModel = MainViewModel()
    
    private var bannerData: [ViewBoxOffice] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController - viewDidLoad()")
        view.backgroundColor = .magenta
        
        configureCollectionView()
        configureLayout()
        setupBindings()
        
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .white
        
        collectionView.delegate = self
        
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.register(KidsCell.self, forCellWithReuseIdentifier: KidsCell.identifier)
        
        collectionView.refreshControl = UIRefreshControl()
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
            if sectionNumber == 0 {
                let itemInset: CGFloat = 0.0
                let sectionMargin: CGFloat = 0.0

                // Item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemInset, bottom: 0, trailing: itemInset)

                // Group
                let pageWidth = self.collectionView.bounds.width - sectionMargin * 2
                //let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(pageWidth)), heightDimension: .estimated(self.collectionView.frame.height))
                let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(pageWidth)), heightDimension: .estimated(CGFloat(pageWidth) * 1.2))
                
                    
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
                
                // Section
                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                return layoutSection
                
            } else {
                
                /// item
                //let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25), heightDimension: .fractionalHeight(0.25)))
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.3)))
                item.contentInsets.top = 8
                item.contentInsets.trailing = 8
                item.contentInsets.bottom = 8
                item.contentInsets.leading = 8
                
                
                /// group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                
                //let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
                
                /// section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 16
                
                return section
                
            }
//            else if sectionNumber == 2{
//
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
//                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
//
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension:  .fractionalWidth(0.7)), subitems: [item])
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                section.orthogonalScrollingBehavior = .continuous
//                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
//
//                /// header
//                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
//                let header = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerSize,
//                    elementKind: TheaterHeader.theaterHeaderId,
//                    alignment: .top
//                )
//
//                section.boundarySupplementaryItems = [
//                    header
//                ]
//
//                return section
//            } else {
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
//                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)
//
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension:  .fractionalWidth(0.7)), subitems: [item])
//
//                let section = NSCollectionLayoutSection(group: group)
//
//                section.orthogonalScrollingBehavior = .continuous
////                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
//
//                section.contentInsets = .init(top: 0, leading: 16, bottom: 100, trailing: 16)
//
//                /// header
//                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
//                let header = NSCollectionLayoutBoundarySupplementaryItem(
//                    layoutSize: headerSize,
//                    elementKind: KidsHeader.kidsHeaderId,
//                    alignment: .top
//                )
//
//                section.boundarySupplementaryItems = [
//                    header
//                ]
//
//                return section
//            }
        }
    }
    
    func configureLayout() {
        // Add Subviews
        view.addSubview(collectionView)
        view.addSubview(loadingView)
        
        // AutoLayout
        collectionView.snp.makeConstraints{make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    //MARK: - Binding
//    func dataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
//        return RxCollectionViewSectionedReloadDataSource<MainSectionModel> (configureCell: { dataSource, collection, indexPath, _  in
//            switch dataSource[indexPath] {
//            case let .BannerSectionItem(
//            }
//        })
//    }
    
    
    
    func setupBindings() {
        // ------------------------------
        //  INPUT
        // ------------------------------
        // 처음 로딩할때 실행
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in
                ()
            }
        
        let reload = collectionView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () } ?? Observable.just(())
        
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchBoxOffices)
            .disposed(by: disposeBag)

        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchKidsBoxOffices)
            .disposed(by: disposeBag)
        
//        viewModel.allBoxOffices
//            .debug()
//            .subscribe(onNext: { [weak self] new in
//                self?.bannerData = new
//            })
//            .disposed(by: disposeBag)
        
        
        // ------------------------------
        //  OUTPUT
        // ------------------------------
//        viewModel.allBoxOffices
//            .bind(to: collectionView.rx.items(cellIdentifier: BannerItemCell.identifier , cellType: BannerItemCell.self)) {
//                index, item, cell in
//                if index == 0 {
//                    cell.onData.onNext(item)
//                }
//            }
//            .disposed(by: disposeBag)
        
        
//        let item = Observable.just([1])
//        
//        // 수정 필요
//        item
//            .bind(to: collectionView.rx.items) { (collectionView, row, element) in
//                let indexPath = IndexPath(row: element, section: 0)
//                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
//
//                return cell
//            }
//            .disposed(by: disposeBag)
        
        
        // loading View
        viewModel.activated
            .map { !$0 } // 초기값 true -> !$0 = false
            .do(onNext: { [weak self] finished in
                if finished {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            })
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
               
        let dataSource = createDataSource()
                
        let section = [
            MainSectionModel.BannerSection(title: "Banner", items: [
                .BannerSectionItem(
                    viewModel.allBoxOffices // BannerCell에 전달해서 BannerItemCell로 바인딩
                )
            ]),
            MainSectionModel.CategorySection(title: "Category", items: [
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
                .CategorySectionItem(image: UIImage(systemName: "sun.min")!, title: "1"),
            ]),
            MainSectionModel.KidsSection(title: "Kids", items: [
                .KidsSectionItem(ViewBoxOffice(BoxOfficeModel(area: "d", prfdtcnt: 1, prfpd: "d", cate: "d", prfplcnm: "d", prfnm: "d", rnum: 1, seatcnt: 1, poster: "d", mt20id: "d"))),
                .KidsSectionItem(ViewBoxOffice(BoxOfficeModel(area: "d", prfdtcnt: 1, prfpd: "d", cate: "d", prfplcnm: "d", prfnm: "d", rnum: 1, seatcnt: 1, poster: "d", mt20id: "d"))),
                .KidsSectionItem(ViewBoxOffice(BoxOfficeModel(area: "d", prfdtcnt: 1, prfpd: "d", cate: "d", prfplcnm: "d", prfnm: "d", rnum: 1, seatcnt: 1, poster: "d", mt20id: "d"))),
            ])
        ]
                
        Observable.just(section)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
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
                guard let cell: KidsCell = collection.dequeueReusableCell(withReuseIdentifier: KidsCell.identifier, for: indexPath) as? KidsCell else { return UICollectionViewCell() }
                return cell
            }
        })
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    
}


