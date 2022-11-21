//
//  CategoryDecorationView.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/21.
//

import Foundation
import UIKit

class CategoryDecorationView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white.withAlphaComponent(1)
        layer.borderColor = UIColor.systemGray.cgColor
        layer.borderWidth = 0
        layer.cornerRadius = 12
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
