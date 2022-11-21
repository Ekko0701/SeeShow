//
//  TheaterHeader.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/10.
//

import Foundation
import UIKit
import SnapKit

class TheaterHeader: UICollectionReusableView {
    static let identifier = "TheaterHeader"
    static let sectionHeaderID = "TheaterHeaderID"
    
    let sectionTitle = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    func configureLayout() {
        addSubview(sectionTitle)
        
        //sectionTitle.text = "HEADER"
        sectionTitle.applyNoToSansKR(text: "이번주 연극 TOP 10", style: .bold, size: 17, color: .black)
        
        sectionTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
