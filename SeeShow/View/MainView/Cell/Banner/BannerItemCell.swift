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
import ChameleonFramework


protocol BannerItemCellDelegate: AnyObject {
    func invalidateTimer()
}

class BannerItemCell: UICollectionViewCell {
    static let identifier = "BannerCollectionViewCell"
    
    private let cellDisposeBag = DisposeBag()
    
    var disposeBag = DisposeBag()
    
    let onData: AnyObserver<ViewBoxOffice> // 데이터를 받아올 Observer
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .backgroundWhite
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 25, weight: .semibold)
        return label
    }()
    
    let bannerImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .backgroundWhite
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        
        let data = PublishSubject<ViewBoxOffice>()
        onData = data.asObserver()
        
        super.init(frame: frame)
        self.backgroundColor = .backgroundWhite
        configureLayout()
        
        // data가 변하면 동작
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] boxoffice in
                let url = URL(string: boxoffice.poster)
                let processor = RoundCornerImageProcessor(cornerRadius: 4)
                self?.bannerImage.kf.indicatorType = .activity
                self?.bannerImage.kf.setImage(with: url,
                                              placeholder: ImagePlaceholderView(),
                                              options: [.processor(processor),
                                                        .cacheOriginalImage
                                                       ]
                ) { result in
                    switch result {
                    case .success(let value):
                        let themeColor = AverageColorFromImage(value.image)
                        self?.bannerImage.backgroundColor = themeColor
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
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
}
