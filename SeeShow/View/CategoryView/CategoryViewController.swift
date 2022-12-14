//
//  CategoryViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxGesture

class CategoryViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let viewModel = CategoryViewModel()
    
    /// NavigationBar
    let navigationBar = CategoryViewHeader()
    
    /// ViewPager의 CollectionView
    private let viewPagerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.layer.masksToBounds = false
        collectionView.layer.shadowColor = UIColor.systemGray.cgColor
        collectionView.layer.shadowOffset = CGSize(width: 0, height: 10)
        collectionView.layer.shadowOpacity = 0.3
        collectionView.layer.shadowRadius = 14

        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.backgroundColor = .backgroundWhite
        
        return collectionView
    }()
    
    /// PageViewController
    var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        return pageViewController
    }()
    
    /// 현재 페이지
    var currentPage: Int = 0 {
        didSet {
            bind(oldValue: oldValue, newValue: currentPage)
        }
    }
    
    var previousPage: Int = 0
    
    var selectedPage: Int = 0
    
    init(selectedPage: Int) {
        self.selectedPage = selectedPage
        previousPage = selectedPage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController - viewDidLoad()")
        
        configurePageView(index: currentPage)
        configurePagerCollection()
        configureStyle()
        configureLayout()
        configureFirstPage(item: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPage = previousPage
        DispatchQueue.main.async { [weak self] in
            self?.viewPagerCollectionView.scrollToItem(at: IndexPath(row: self?.currentPage ?? 0, section: 0), at: .centeredHorizontally, animated: true) }
        
        tabBarController?.tabBar.isHidden = false
        configureNavBar()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
        navigationBar.navigationHeight = 45
        
        navigationBar.delegate = self
    }
    
    /// ViewPagerCollectionView 설정
    private func configurePagerCollection() {
        // Attach Delegate, DataSource
        viewPagerCollectionView.delegate = self
        viewPagerCollectionView.dataSource = self
        
        // Register
        viewPagerCollectionView.register(ViewPagerCell.self, forCellWithReuseIdentifier: ViewPagerCell.identifier)
    }
    
    /// ViewPagerCollection의 처음 페이지를 item: Int
    private func configureFirstPage(item: Int) {
        let firstIndexPath = IndexPath(item: item, section: 0)
        viewPagerCollectionView.selectItem(at: firstIndexPath, animated: false, scrollPosition: .right)
    }
    
    private func configureStyle() {
        view.backgroundColor = .backgroundWhite
    }
    
    private func configureLayout() {
        // Add Subview
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(viewPagerCollectionView)
        view.addSubview(navigationBar)
        
        // Constraint
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(navigationBar.containerView)
        }
        
        viewPagerCollectionView.snp.makeConstraints { make in
            //make.top.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(viewPagerCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }

        pageViewController.didMove(toParent: self)
    }
    
    /// viewPagerCollectionView의 cell을 터치할때 실행 - CurrentPage를 선택한 Page로 바꿔준다.
    func didTapCell(at indexPath: IndexPath) {
        currentPage = indexPath.item
        previousPage = indexPath.item
    }
    
    /// PageViewController 설정
    private func configurePageView(index: Int) {
        pageViewController.delegate = self
        pageViewController.dataSource = self 
        let firstVC = viewModel.pageViewControllers[index]
        
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
    }
    
    private func bind(oldValue: Int, newValue: Int) {
        // collectionView에서 선택한 경우
        let direction: UIPageViewController.NavigationDirection = oldValue < newValue ? .forward : .reverse
        pageViewController.setViewControllers([viewModel.pageViewControllers[currentPage]], direction: direction, animated: true, completion: nil)
        
        // pageViewController에서 paging한 경우
        viewPagerCollectionView.selectItem(at: IndexPath(item: currentPage, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
}

//MARK: - UICollectionViewDelegate
extension CategoryViewController: UICollectionViewDelegate {
    
}
//MARK: - UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewPagerCell.identifier, for: indexPath) as? ViewPagerCell else { return UICollectionViewCell() }
        cell.configure(data: viewModel.categories[indexPath.row])
        
        // collection View Touch 구현
        cell.touchingView.rx.tapGesture(configuration: .none)
            .when(.recognized)
            .asDriver { _ in .never() }
            .drive(onNext: { [weak self] _ in
                self?.didTapCell(at: indexPath)
            }).disposed(by: cell.disposeBag)
        
        return cell
    }
}

//MARK: - UICollectionViewFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width / 5
        let height = collectionView.frame.height
        
        let size: CGSize = CGSize(width: width, height: height)
        return size
    }
}

//MARK: - UIPageViewControllerDelegate & DataSource
extension CategoryViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.pageViewControllers.firstIndex(of: viewController) else { return nil }
        let previousIndex = index - 1
        if previousIndex < 0 {
            return nil
        }
        return viewModel.pageViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewModel.pageViewControllers.firstIndex(of: viewController) else { return nil }
        let nextIndex = index + 1
        if nextIndex == viewModel.pageViewControllers.count {
            return nil
        }
        return viewModel.pageViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let currentVC = pageViewController.viewControllers?.first,
              let currentIndex = viewModel.pageViewControllers.firstIndex(of: currentVC) else { return }
        currentPage = currentIndex
    }
    
}

//MARK: - CategoryNavigationBarProtocol
extension CategoryViewController: CategoryViewHeaderProtocol {
    
    func touchBackButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
}
//MARK: - Preview

//#if DEBUG
//import SwiftUI
//struct CategoryViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryViewController().getPreview()
//            .ignoresSafeArea()
//    }
//}
///// option + command +enter -> 접었다 폈다
///// option + command + p -> 미리보기 실행
//#endif
