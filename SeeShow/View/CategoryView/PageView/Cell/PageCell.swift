//
//  PageCell.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/15.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import RxSwift
import RxCocoa
import RxRelay

class PageCell: UITableViewCell {
    static let identifier = "PageCell"
    
    var disposeBag = DisposeBag()
    
    let image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "house")
        
        return imageView
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.applyNoToSansKR(text: "Empty", style: .regular, size: 20, color: .black)
        
        return label
    }()
    
    private let place: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.applyNoToSansKR(text: "Empty", style: .regular, size: 20, color: .black)
        
        return label
    }()
    
    private let period: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.applyNoToSansKR(text: "Empty", style: .regular, size: 20, color: .black)
        
        return label
    }()
    
    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureLayout()
        self.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        // Add Subview
        contentView.addSubview(image)
        contentView.addSubview(infoStack)
        
        // Add Subview to infoStack
        infoStack.addArrangedSubview(title)
        infoStack.addArrangedSubview(place)
        infoStack.addArrangedSubview(period)
        
        // Constraint
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(image.snp.height).multipliedBy(0.7)
        }
        
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top)
            make.bottom.equalTo(image.snp.bottom)
            make.leading.equalTo(image.snp.trailing).offset(8)
        }
    }
    
    func configure(with data: ViewPageData) {
//        data.observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] boxoffice in
//
//                let url = URL(string: boxoffice.poster)
//                self?.image.kf.indicatorType = .activity
//                self?.image.kf.setImage(with: url,
//                                        placeholder: ImagePlaceholderView(),
//                                        options: [
//                                                  .cacheOriginalImage
//                                        ]
//                )
//                self?.title.text = boxoffice.prfnm
//            }).disposed(by: disposeBag)
        let url = URL(string: data.poster)
        image.kf.indicatorType = .activity
        image.kf.setImage(with: url,
        placeholder: ImagePlaceholderView(),
        options:  [
            .cacheOriginalImage
        ])
        self.title.text = data.prfnm
        self.place.text = data.prfplcnm
        self.period.text = data.prfpd
        print("test \(data)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
