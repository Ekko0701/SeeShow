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
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    var disposeBag = DisposeBag()
    private let cellDisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 레이아웃 설정
    func configureLayout() {
        // Add Subview
        contentView.addSubview(image)
        
        // AutoLayout
        image.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with data: Observable<ViewBoxOffice>) {
        print("BannerCell \(data)")
        data.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] boxoffice in
                let url = URL(string: boxoffice.poster)
                self?.image.kf.indicatorType = .activity
                self?.image.kf.setImage(with: url,
                                        placeholder: ImagePlaceholderView()
                )
            }).disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
