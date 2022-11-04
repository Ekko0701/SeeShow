//
//  ImagePlaceholderView.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class ImagePlaceholderView: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.text = "이미지 준비중 입니다."
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .systemGray
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        // Add Subview
        self.addSubview(title)
        
        // AutoLayout
        title.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}


extension ImagePlaceholderView: Placeholder { }
