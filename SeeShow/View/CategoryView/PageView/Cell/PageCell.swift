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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.applyBorder(color: .backgroundGray, radius: 0)
        
        return imageView
    }()
    
    private let titleBehindView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    private let title: UILabel = {
        let label = UILabel()
        
        label.applyNoToSansKR(text: "", style: .bold, size: 16, color: .black)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let place: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.applyNoToSansKR(text: "", style: .regular, size: 14, color: .black)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let period: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.applyNoToSansKR(text: "", style: .regular, size: 14, color: .black)
        label.numberOfLines = 2
        
        return label
    }()
    
    private let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 4
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .backgroundWhite
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        // Add Subview
        contentView.addSubview(image)
        contentView.addSubview(infoStack)
        
        // Add Subview to infoStack
        infoStack.addArrangedSubview(titleBehindView)
        infoStack.addArrangedSubview(place)
        infoStack.addArrangedSubview(period)
        
        titleBehindView.addSubview(title)
        
        // Constraint
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.width.equalTo(image.snp.height).multipliedBy(0.7)
        }
        
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(4)
            make.leading.equalTo(image.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
        
        title.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
            make.trailing.equalToSuperview().offset(-8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(with data: ViewPageData) {
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
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
}
