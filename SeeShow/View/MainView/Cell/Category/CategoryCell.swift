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
        //imageView.image = UIImage(systemName: "house")
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        
        return imageView
    }()
    
    let title: UILabel = {
        let label = UILabel()
        //label.textColor = .black
        //label.applyNoToSansKR(style: .light, size: 16, color: .black)
        label.textAlignment = .center

        return label
    }()
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        configureStyle()
        self.backgroundColor = .cyan
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
            make.top.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(image.snp.width).multipliedBy(1)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
