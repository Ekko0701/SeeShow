//
//  MainCollectionViewCell.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/09.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa

class MainCollectionViewCell: UICollectionViewCell {
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        
        label.applyNoToSansKR(style: .medium, size: 16, color: .black)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping

        return label
    }()
    
    var disposeBag = DisposeBag()
    private let cellDisposeBag = DisposeBag()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        configureStyle()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 셀 스타일 설정
    func configureStyle() {
    }
    
    /// 레이아웃 설정
    func configureLayout() {
        // Add Subview
        contentView.addSubview(image)
        contentView.addSubview(title)
        
        // Configure Constraints
        image.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()

            make.width.equalToSuperview()
            make.height.equalTo(image.snp.width).multipliedBy(1.35)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(with data: Observable<ViewBoxOffice>) {
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] boxoffice in
                let url = URL(string: boxoffice.poster)
                let processor = RoundCornerImageProcessor(cornerRadius: 16)
                self?.image.kf.indicatorType = .activity
                self?.image.kf.setImage(with: url,
                                        placeholder: ImagePlaceholderView(),
                                        options: [.processor(processor),
                                                  .cacheOriginalImage
                                        ]
                )
                self?.title.text = boxoffice.prfnm
            }).disposed(by: cellDisposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
