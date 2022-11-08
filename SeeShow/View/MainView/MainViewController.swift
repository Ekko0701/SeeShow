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
    private var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.alpha = 1
        
        return view
    }()
    
    let viewModel = MainViewModel()
    let disposeBag = DisposeBag()
    let touchCell = PublishSubject<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MainViewController - viewDidLoad()")
        view.backgroundColor = .magenta
        
        configureCollectionView()
        configureLayout()
        setupBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    /// CollectionView 설정
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .white
        
        // Attach Delegate
        collectionView.delegate = self
        
        // Register Cell
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.register(KidsCell.self, forCellWithReuseIdentifier: KidsCell.identifier)
        
        // Register SupplementaryView
        collectionView.register(KidsSectionHeader.self, forSupplementaryViewOfKind: KidsSectionHeader.sectionHeaderID, withReuseIdentifier: KidsSectionHeader.identifier)
        
        // Add UIRefreshControl()
        collectionView.refreshControl = UIRefreshControl()
    }
    
    /// Compositional 레이아웃 생성
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout{
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
                let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .absolute(CGFloat(pageWidth)), heightDimension: .estimated(CGFloat(pageWidth) * 1.2))
                
                let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
                
                // Section
                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
                
                return layoutSection
                
            } else if sectionNumber == 1 {
                
                // item
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.2), heightDimension: .fractionalWidth(0.3)))
                item.contentInsets.top = 8
                item.contentInsets.trailing = 8
                item.contentInsets.bottom = 8
                item.contentInsets.leading = 8
                
                // group
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(500)), subitems: [item])
                
                // section
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                section.contentInsets.trailing = 16
                section.contentInsets.bottom = 16
                
                return section
                
            } else {

                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1)))
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

                return section
            }
//            else {
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
    
    /// 레이아웃 설정
    private func configureLayout() {
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
            .bind(to: viewModel.fetchKidsBoxOffices)
            .disposed(by: disposeBag)
        

        
        // ------------------------------
        //  OUTPUT
        // ------------------------------
        
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
               
        // DataSource
        let dataSource = createDataSource()
                
        // Section, SectionItems
        let section = [
            MainSectionModel.BannerSection(title: "Banner", items: [
                .BannerSectionItem(
                    viewModel.allBoxOffices // BannerCell에 전달해서 BannerItemCell로 바인딩
                )
            ]),
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
            MainSectionModel.KidsSection(title: "Kids", items: [
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[0] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[1] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[2] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[3] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[4] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[5] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[6] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[7] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[8] }),
                .KidsSectionItem(viewModel.pushKidsBoxOffices.map { $0[9] }),
            ])
        ]
                
         
                
        // DataSource에 Section Header 추가
        dataSource.configureSupplementaryView = {(dataSource, collection, kind, indexPath) in
            guard let cell = collection.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: KidsSectionHeader.identifier , for: indexPath) as? KidsSectionHeader else { return UICollectionReusableView() }
            //cell.sectionTitle.text = "주긴 Kids 인기 순위"
            return cell
        }
        
        Observable.just(section)
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        //MARK: - CollectionView Item seleted - 작업중
        
        // 셀 선택 ( 다음의 코드는 2번 Section의 ItemSeleted Event만 해당함)
        collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
            self?.collectionView.deselectItem(at: indexPath, animated: true)
            if indexPath.section == 2 {
                self?.viewModel.touchKidsBoxOfficeCell.onNext(indexPath.item)
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
    
    /// CollectionView의 DataSource생성
    private func createDataSource() -> RxCollectionViewSectionedReloadDataSource<MainSectionModel> {
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
                
            case let .KidsSectionItem(data):
                guard let cell: KidsCell = collection.dequeueReusableCell(withReuseIdentifier: KidsCell.identifier, for: indexPath) as? KidsCell else { return UICollectionViewCell() }
                cell.configure(with: data)
                return cell
            }
        })
    }
}

//MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
}


