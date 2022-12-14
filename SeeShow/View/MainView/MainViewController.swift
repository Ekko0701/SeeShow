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
import ChameleonFramework

class MainViewController: UIViewController, TouchCellProtocol {
    var collectionView: UICollectionView!
    var dataSource: RxCollectionViewSectionedReloadDataSource<MainSectionModel>!
    
    var navigationBar = MainNavigationBar()
    
    var loadingView = MainLoadingView()
    
    private var topBackGroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundWhite
        return view
    }()
    
    let viewModel = MainViewModel()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController - viewDidLoad()")
        
        configureCollectionView()
        configureLayout()
        configureStyle()
        
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        configureNavBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        skeletonLoading()
        
    }
    
    private func skeletonLoading() {
        let loadingView = self.loadingView
        loadingView.firstView.animateShimmer()
        loadingView.secondView.animateShimmer()
        loadingView.thirdView.animateShimmer()
        loadingView.bannerView.animateShimmer()
        loadingView.categoryView.animateShimmer()
    }
    
    /// NavigationBar 설정
    private func configureNavBar() {
        
        // 기존 NavigationBar 숨김
        self.navigationController?.navigationBar.isHidden = true
        navigationBar.navigationHeight = 60
        
        navigationBar.delegate = self
    }
    
    /// View Style 설정
    private func configureStyle() {
        self.tabBarController?.tabBar.isHidden = true
        view.backgroundColor = .backgroundWhite
    }
    
    /// CollectionView 설정
    private func configureCollectionView() {
        let layout = createCompositionalLayout()
        layout.register(CategoryDecorationView.self, forDecorationViewOfKind: "CategoryDecorationView")
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.backgroundColor = .backgroundGray
        
        collectionView.dataSource = nil
        
        // Register Cell
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.register(TheaterCell.self, forCellWithReuseIdentifier: TheaterCell.identifier)
        collectionView.register(UNICell.self, forCellWithReuseIdentifier: UNICell.identifier)
        collectionView.register(OpenRunCell.self, forCellWithReuseIdentifier: OpenRunCell.identifier)
        collectionView.register(KidsCell.self, forCellWithReuseIdentifier: KidsCell.identifier)
        
        // Register SupplementaryView
        collectionView.register(KidsSectionHeader.self, forSupplementaryViewOfKind: KidsSectionHeader.sectionHeaderID, withReuseIdentifier: KidsSectionHeader.identifier)
        collectionView.register(TheaterHeader.self, forSupplementaryViewOfKind: TheaterHeader.sectionHeaderID, withReuseIdentifier: TheaterHeader.identifier)
        collectionView.register(UNIHeader.self, forSupplementaryViewOfKind: UNIHeader.sectionHeaderID, withReuseIdentifier: UNIHeader.identifier)
        collectionView.register(OpenRunHeader.self, forSupplementaryViewOfKind: OpenRunHeader.sectionHeaderID, withReuseIdentifier: OpenRunHeader.identifier)
        
        // Add UIRefreshControl()
        // 현재 refresh 제거한싱테
        // collectionView.refreshControl = UIRefreshControl()
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
    }
    
    /// Compositional 레이아웃 생성
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
        return UICollectionViewCompositionalLayout{ (sectionNumber, env) -> NSCollectionLayoutSection? in
            // Banner Section
            if sectionNumber == 0 {
                let itemInset: CGFloat = 0.0
                let sectionMargin: CGFloat = 0.0

                // Item
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
                let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
                layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: itemInset, bottom: 0, trailing: itemInset)

                // Group
                let pageWidth = self.collectionView.bounds.width - sectionMargin * 2
                let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(pageWidth)), heightDimension: .estimated(CGFloat(pageWidth) * 1.3))
                
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
                
                // Section
                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                return layoutSection
            }
            // Category Section
            else if sectionNumber == 1 {
                
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.25)))
                item.contentInsets.top = 8
                item.contentInsets.trailing = 8
                item.contentInsets.bottom = 0
                item.contentInsets.leading = 8
                
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.top = 0
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 16
                
                // DecorationView
                let decorationView = NSCollectionLayoutDecorationItem.background(elementKind: "CategoryDecorationView")
                decorationView.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
                section.decorationItems = [decorationView]
                
                return section
                
            }
            // Theater Section
            else if sectionNumber == 2 {

                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.6)))
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension:  .fractionalWidth(0.7)), subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

                /// header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: TheaterHeader.sectionHeaderID,
                    alignment: .top
                )

                section.boundarySupplementaryItems = [
                    header
                ]
                
                // DecorationView
                let decorationView = NSCollectionLayoutDecorationItem.background(elementKind: "CategoryDecorationView")
                decorationView.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
                
                section.decorationItems = [decorationView]

                return section
                
            }
            // UNI Section
            else if sectionNumber == 3 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.6)))
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension:  .fractionalWidth(0.7)), subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

                /// header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: UNIHeader.sectionHeaderID,
                    alignment: .top
                )

                section.boundarySupplementaryItems = [
                    header
                ]

                // DecorationView
                let decorationView = NSCollectionLayoutDecorationItem.background(elementKind: "CategoryDecorationView")
                decorationView.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
                
                section.decorationItems = [decorationView]
                
                return section
            }
            // OPENRun Section
            else if sectionNumber == 4 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.6)))
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension:  .fractionalWidth(0.7)), subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

                /// header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: OpenRunHeader.sectionHeaderID,
                    alignment: .top
                )

                section.boundarySupplementaryItems = [
                    header
                ]

                // DecorationView
                let decorationView = NSCollectionLayoutDecorationItem.background(elementKind: "CategoryDecorationView")
                decorationView.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
                
                section.decorationItems = [decorationView]
                return section
            }
            // Kids Section
            else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1.6)))
                item.contentInsets = .init(top: 0, leading: 5, bottom: 0, trailing: 5)

                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.4), heightDimension:  .fractionalWidth(0.7)), subitems: [item])

                let section = NSCollectionLayoutSection(group: group)

                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)

                /// header
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50))
                let header = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: headerSize,
                    elementKind: KidsSectionHeader.sectionHeaderID,
                    alignment: .top
                )

                section.boundarySupplementaryItems = [
                    header
                ]

                // DecorationView
                let decorationView = NSCollectionLayoutDecorationItem.background(elementKind: "CategoryDecorationView")
                decorationView.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
                
                section.decorationItems = [decorationView]
                
                return section
            }
        }
    }
    
    /// 레이아웃 설정
    private func configureLayout() {
        // Add Subviews
        
        view.addSubview(collectionView)
        view.addSubview(navigationBar)
        view.addSubview(loadingView)
        
        // AutoLayout
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(navigationBar.containerView)
        }
        
        collectionView.snp.makeConstraints{make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //MARK: - Binding
    /// Binding 설정
    func setupBindings() {
        // ------------------------------
        //  INPUT
        // ------------------------------
        
        // viewWillAppear시 이벤트 발생
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in
                ()
            }
        // Refresh시 이벤트 발생
        let reload = collectionView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () } ?? Observable.just(())
        
        // Load 또는 Refresh될 때 viewModel에서 api호출
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchBoxOffices)
            .disposed(by: disposeBag)

        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchTheaterBoxOffices)
            .disposed(by: disposeBag)
        
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchUNIBoxOffices)
            .disposed(by: disposeBag)
        
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchOpenRunBoxOffices)
            .disposed(by: disposeBag)
        
        Observable.merge([firstLoad, reload])
            .bind(to: viewModel.fetchKidsBoxOffices)
            .disposed(by: disposeBag)
        
    
        // ------------------------------
        //  OUTPUT
        // ------------------------------
        
        // Error
        viewModel.errorMessage
            .map { $0.domain }
            .subscribe(onNext: { [weak self] err in
                let alert = UIAlertController(title: "Network Error", message: err, preferredStyle: UIAlertController.Style.alert)
                let endAction = UIAlertAction(title: "종료", style: .default) { (action) in
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                alert.addAction(endAction)
                self?.present(alert, animated: false, completion: nil)
            }).disposed(by: disposeBag)
        
        // Loading View
        viewModel.activated
            .map { !$0 }
            .do(onNext: { [weak self] finished in
                if finished {
                    self?.collectionView.refreshControl?.endRefreshing()
                }
            })
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
               
        // Create DataSource
        dataSource = createDataSource()
                
        // Create Section Items
        let section = viewModel.section
         
        // dataSource에 Section Header 추가
        dataSource.configureSupplementaryView = {(dataSource, collection, kind, indexPath) in
            switch dataSource[indexPath] {
            case .TheaterSectionItem:
                guard let cell = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TheaterHeader.identifier , for: indexPath) as? TheaterHeader else { return UICollectionReusableView() }
                return cell
            case .UNISectionItem:
                guard let cell = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: UNIHeader.identifier , for: indexPath) as? UNIHeader else { return UICollectionReusableView() }
                return cell
            case .OpenRunSectionItem:
                guard let cell = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: OpenRunHeader.identifier , for: indexPath) as? OpenRunHeader else { return UICollectionReusableView() }
                return cell
            case .KidsSectionItem:
                guard let cell = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KidsSectionHeader.identifier , for: indexPath) as? KidsSectionHeader else { return UICollectionReusableView() }
                return cell
            default:
                return UICollectionReusableView()
                
            }
        }
        
        // CollectionView와 바인딩할 BehaviorRelay 생성
        let sectionSubject = BehaviorRelay(value: [MainSectionModel]())
        
        sectionSubject.accept(section)
        
        // CollectionView 바인딩
        sectionSubject
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //MARK: - CollectionView Item seleted & Push View
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            if indexPath.section == 1 {
                let vc = CategoryViewController(selectedPage: indexPath.item)
                
                vc.navigationBar.updateLayout()
                
                self?.navigationController?.pushViewController(vc, animated: true)
                
            } else {
                self?.collectionView.deselectItem(at: indexPath, animated: true)
                self?.viewModel.touchCell.onNext(indexPath)
            }
            
        }).disposed(by: disposeBag)
        
        // 화면 전환
        viewModel.showDetailPage.subscribe (onNext: { [weak self] performanceID in
            let vc = DetailViewController()
            vc.viewModel = DetailViewModel(domain: DetailStore(id: performanceID))
            self?.navigationController?.pushViewController(vc, animated: true)
            }
        ).disposed(by: disposeBag)
                                                 
    }
    
    func touchBannerCell(_ IndexPath: IndexPath) {
        viewModel.touchCell.onNext(IndexPath)
    }
    
    /// CollectionView의 DataSource생성
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
        return RxCollectionViewSectionedReloadDataSource<MainSectionModel>(configureCell: {dataSource, collection, indexPath, item in
            switch dataSource[indexPath] {
            case let .BannerSectionItem(data):
                guard let cell: BannerCell = collection.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else { return UICollectionViewCell() }
                cell.delegate = self
                cell.configure(data: data)
                return cell
                
            case let .CategorySectionItem(image, title):
                guard let cell: CategoryCell = collection.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else { return UICollectionViewCell() }
                cell.configure(image: image, title: title)
                return cell
                
            case let .TheaterSectionItem(data):
                guard let cell: TheaterCell = collection.dequeueReusableCell(withReuseIdentifier: TheaterCell.identifier, for: indexPath) as? TheaterCell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
                
            case let .UNISectionItem(data):
                guard let cell: UNICell = collection.dequeueReusableCell(withReuseIdentifier: UNICell.identifier, for: indexPath) as? UNICell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
                
            case let .OpenRunSectionItem(data):
                guard let cell: OpenRunCell = collection.dequeueReusableCell(withReuseIdentifier: OpenRunCell.identifier, for: indexPath) as? OpenRunCell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
                
            case let .KidsSectionItem(data):
                guard let cell: KidsCell = collection.dequeueReusableCell(withReuseIdentifier: KidsCell.identifier, for: indexPath) as? KidsCell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
            }
        })
    }
}

extension MainViewController: MainNavigationBarProtocol {
    func touchRightButton() {
        self.tabBarController?.selectedIndex = 2
    }
}

//MARK: - Preview

#if DEBUG
import SwiftUI
struct MainViewController_Previews: PreviewProvider {
    static var previews: some View {
        MainViewController().getPreview()
            .ignoresSafeArea()
    }
}
/// option + command +enter -> 접었다 폈다
/// option + command + p -> 미리보기 실행
#endif
