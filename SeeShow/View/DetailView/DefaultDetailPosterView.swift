//
//  DefaultDetailPosterView.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/23.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class DefaultDetailPosterView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.tintColor = .backgroundWhite
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .backgroundGray
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        // Add Subview
        self.addSubview(imageView)
        
        // AutoLayout
        imageView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
