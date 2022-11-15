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

class CategoryViewController: UIViewController {
    let disposeBag = DisposeBag()
    let viewModel = CategoryViewModel()
    
    /// ViewPager의 CollectionView
    private let viewPagerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController - viewDidLoad()")
        view.backgroundColor = .systemGreen
        
        configurePageView()
        configurePagerCollection()
        configureLayout()
        configureFirstPage(item: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentPage = 0
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
    
    private func configureLayout() {
        // Add Subview
        view.addSubview(viewPagerCollectionView)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        // Constraint
        viewPagerCollectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
    }
    
    /// PageViewController 설정
    #warning("TODO : - 첫번째 페이지 수정해야함 ")
    private func configurePageView() {
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let firstVC = viewModel.pageViewControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
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
//MARK: - Preview

#if DEBUG
import SwiftUI
struct CategoryViewController_Previews: PreviewProvider {
    static var previews: some View {
        CategoryViewController().getPreview()
            .ignoresSafeArea()
    }
}
/// option + command +enter -> 접었다 폈다
/// option + command + p -> 미리보기 실행
#endif
