//
//  KidsSectionHeader.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/03.
//

import Foundation
import UIKit
import SnapKit

class KidsSectionHeader: UICollectionReusableView {
    static let identifier = "KidsSectionHeader"
    static let sectionHeaderID = "KidsSectionHeaderID"
    
    let sectionTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(sectionTitle)
        
        sectionTitle.text = "HEADER"
        
        sectionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.top.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
