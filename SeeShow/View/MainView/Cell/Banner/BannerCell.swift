//
//  BannerCell.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

class BannerCell: UICollectionViewCell {

    static let identifier = "BannerCell"
    
    var autoScrollTimer: Timer!
    
    let cellWidthMultiplier: CGFloat = 0.7
    let cellHeightMultiplier: CGFloat = 0.8
    let minimumLineSpacing: CGFloat = 20
    
    var currentIndex: CGFloat = 0 // 현재 CollectionView의 페이지 인덱스
    var previousIndex = 0
    
    var firstItemHlighted = true
    
    var itemCount: Int = 1
    
    let viewModel = MainViewModel()
    
    let disposeBag = DisposeBag()
    
    var dataArray: [ViewBoxOffice] = []
    
    private let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .yellow
        return collectionView
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCollectionView()
        configureLayout()
        //setupBindings()
        pagingTimer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCollectionView() {
        collectionView.register(BannerItemCell.self, forCellWithReuseIdentifier: BannerItemCell.identifier)
        collectionView.delegate = self
    }
    
    private func configureLayout() {
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.leading.equalToSuperview()
        }
    }
    
    func setupBindings() {
        viewModel.allBoxOffices
            .bind(to: collectionView.rx.items(cellIdentifier: BannerItemCell.identifier , cellType: BannerItemCell.self)) {
                _, item, cell in

                cell.onData.onNext(item)
            }
            .disposed(by: disposeBag)
        
        //viewModel.
    }
    
    func configure(data: Observable<[ViewBoxOffice]> ) {
        print("Banner Cell입니다. \(dataArray)")
        
        data
            .bind(to: collectionView.rx.items(cellIdentifier: BannerItemCell.identifier , cellType: BannerItemCell.self)) {
            _, item, cell in

            cell.onData.onNext(item)
        }
        .disposed(by: disposeBag)
    }
}



//MARK: - UICollectionViewDelegate
extension BannerCell: UICollectionViewDelegate {
    /// ScrollViewWillEndDragging
    /// 드래그를 마칠때 호출되는 메서드
    /// 드래그를 마칠때 ContentOffset을 조절하자.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // Cell의 너비
        let width: CGFloat = collectionView.frame.size.width * cellWidthMultiplier
        
        // Cell간 간격을 포함한 Cell의 너비
        let cellWidthIncludingSpacing = width + minimumLineSpacing
        
        // 스크롤 정지시 예상되는 위치
        var offset = targetContentOffset.pointee
        
        // 스크롤 정지시 예상되는 x축 위치와 스크롤뷰의 좌측 Inset을 더한 값을
        // Cell간 간격을 포함한 Cell의 너비로 나눈다.
        // 그 값이 index
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        
        // Index 값을 반올림한다.
        var roundedIndex = round(index)
        
        // 한 페이지씩 스크롤
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else if scrollView.contentOffset.x < targetContentOffset.pointee.x {
            roundedIndex = ceil(index)
        } else {
            roundedIndex = round(index)
        }
        
        if currentIndex > roundedIndex {
            currentIndex -= 1
            roundedIndex = currentIndex
        } else if currentIndex < roundedIndex {
            currentIndex += 1
            roundedIndex = currentIndex
        }
        
        
        // 새로운 OffSet을 설정한다.
        // roundedIndex값에 cellWidthIncludingSpacing값을 곱하고 scrollView의 좌측 Inset만큼 빼준다.
        // (Rounded Index 번째의 Cell의 x축을 알기 위함)
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        
        // Offset 적용
        targetContentOffset.pointee = offset
    }
    
    
    ///
    ////// Scroll View Did Scroll
    /// Add Hight Effect
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Cell의 너비
        let width: CGFloat = collectionView.frame.size.width * cellWidthMultiplier
        
        // Cell간 간격을 포함한 Cell의 너비
        let cellWidthIncludingSpacing = width + minimumLineSpacing
        
        let offsetX = collectionView.contentOffset.x
        let index = (offsetX + collectionView.contentInset.left) / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        
        // 1번 방법
        // 작동 but 비정상
        if let cell = collectionView.cellForItem(at: indexPath) {
            applyAnimation(cell: cell)
        }
        
        if Int(roundedIndex) != previousIndex {
            let preIndexPath = IndexPath(item: previousIndex, section: 0)
            if let preCell = collectionView.cellForItem(at: preIndexPath) {
                removeAnimation(cell: preCell)
            }
            previousIndex = indexPath.item
        }
    }
    
    /// willDisplay
    /// 첫번째 Item 크기 조절
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 && firstItemHlighted == true {
            firstItemHlighted = false
            applyAnimation(cell: cell)
        } else {
            removeAnimation(cell: cell)
        }
    }
}

//MARK: - UICollectionViewFlowLayout
extension BannerCell: UICollectionViewDelegateFlowLayout {
    /// Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width: CGFloat = collectionView.frame.size.width * cellWidthMultiplier
        let height: CGFloat = collectionView.frame.size.height * cellHeightMultiplier
        
        let size: CGSize = CGSize(width: width, height: height)
        
        return size
    }
    
    /// MinimumLineSpacing
    /// Cell간 최소 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return minimumLineSpacing
    }
    
    /// Inset
    /// Section의 Contents 여백
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        // 첫번째 Cell이 중앙에 오도록 설정하자.
        let width: CGFloat = collectionView.frame.size.width * cellWidthMultiplier
        
        let insetX = (contentView.frame.size.width - width) / 2.0
        
        let inset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        
        return inset
    }
}

//MARK: - Auto Paging
extension BannerCell {
    
    /// Auto Paging 타이머 실행
    func pagingTimer() {
        autoScrollTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { Timer in
            self.moveToNextPage()
        }
    }

    /// Auto Paging 페이지 전환
    func moveToNextPage() {
        // Cell의 너비
        let width: CGFloat = collectionView.frame.size.width * cellWidthMultiplier
        let height: CGFloat = collectionView.frame.size.height * cellHeightMultiplier
        
        // Cell간 간격을 포함한 Cell의 너비
        let cellWidthIncludingSpacing = width + minimumLineSpacing
        
        // Inset
        let insetX = (contentView.frame.size.width - width)
        
        // ContentOffset: 현재 스크롤 위치
        let contentOffset = collectionView.contentOffset
        
        // if - 마지막 페이지가 아닌 경우
        ///------------------------------------
        //////------------------------------------///------------------------------------
        //////------------------------------------///------------------------------------
        //////------------------------------------///------------------------------------
        if Int(currentIndex) != 10 - 1 {
            collectionView.scrollRectToVisible(CGRectMake(contentOffset.x + width + insetX, contentOffset.y, cellWidthIncludingSpacing, height ), animated: true)
            
            currentIndex += 1
        }
        ///------------------------------------///------------------------------------///------------------------------------///------------------------------------
        //////------------------------------------///------------------------------------///------------------------------------
        
        // else - 마지막 페이지인 경우
        else {
            collectionView.scrollRectToVisible(CGRectMake( 0, contentOffset.y, cellWidthIncludingSpacing, height), animated: true)
            
            currentIndex = 0
        }
    }
}

//MARK: - Focus Cell Animation
extension BannerCell {
    func applyAnimation(cell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                cell.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        },
            completion: nil
        )
    }
    
    func removeAnimation(cell: UICollectionViewCell) {
        UIView.animate(
                    withDuration: 0.4,
                    delay: 0,
                    options: .curveEaseOut,
                    animations: {
                        cell.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                },
                    completion: nil)
    }
}

//MARK: - Invalidate Timer
extension BannerCell: BannerItemCellDelegate {
    func invalidateTimer() {
        print("BannerCell - invalidateTimer() called")
        if autoScrollTimer != nil {
            autoScrollTimer.invalidate()
            autoScrollTimer = nil
        }
    }
}
