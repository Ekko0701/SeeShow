//
//  BannerItemCell.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import RxSwift


protocol BannerItemCellDelegate: AnyObject {
    func invalidateTimer()
}

class BannerItemCell: UICollectionViewCell {
    static let identifier = "BannerCollectionViewCell"
    
    //weak var delegate: BannerItemCellDelegate?
    
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    
    let onData: AnyObserver<ViewBoxOffice> // 데이터를 받아올 Observer
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "기본값 test"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    let bannerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "house") // test
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        let data = PublishSubject<ViewBoxOffice>()
        onData = data.asObserver()
        
        super.init(frame: frame)
        
        configureLayout()
        
        // data가 변하면 동작
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] boxoffice in
                //self?.bannerImage.image = UIImage(systemName: "house")
                let url = URL(string: boxoffice.poster)
                let processor = RoundCornerImageProcessor(cornerRadius: 8)
                self?.bannerImage.kf.indicatorType = .activity
                self?.bannerImage.kf.setImage(with: url,
                                              placeholder: ImagePlaceholderView(),
                                              options: [.processor(processor),
                                                        .cacheOriginalImage
                                                       ]
                )
            })
            .disposed(by: cellDisposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    /// Layout 설정
    func configureLayout() {
        
        //  Add Subviews
        contentView.addSubview(bannerImage)
        
        bannerImage.snp.makeConstraints { make in
            make.top.bottom.trailing.left.equalToSuperview()
        }
    }
    
    func gesture() {
        
    }
    
//    @objc
//    private func handlePan(_ pan: UIPanGestureRecognizer) {
//        print("BannerCollectionViewCell - handlePan(_:) called")
//        delegate?.invalidateTimer()
//    }
}

////MARK: - UIGestureRecognizerDelegate
//extension BannerItemCell: UIGestureRecognizerDelegate {
//    /// if true
//    /// 동시 여러 제스처 인식 허용
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//}
