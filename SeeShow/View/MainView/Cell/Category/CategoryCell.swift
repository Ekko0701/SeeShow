//
//  CategoryCell.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
import SnapKit

class CategoryCell: UICollectionViewCell {
    static let identifier = "CategoryCell"
    
    private let image: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(style: .light, size: 16, color: .black)
        label.textAlignment = .center

        return label
    }()
    
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
//            make.top.leading.trailing.equalToSuperview()
//            make.width.equalToSuperview()
//            make.height.equalTo(image.snp.width).multipliedBy(1)
            make.top.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.height.equalTo(image.snp.width).multipliedBy(1)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(image: UIImage, title: String) {
        self.image.image = image
        self.title.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
