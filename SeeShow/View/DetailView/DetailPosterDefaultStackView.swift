//
//  DetailPosterDefaultStackView.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/08.
//

import Foundation
import UIKit
import SnapKit

class DetailPosterDefaultStackView: UIView {
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
    
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        // Add Subview
        self.addSubview(backgroundView)
        
        // AutoLayout
        backgroundView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
            //make.height.equalTo(200)
        }
    }
}
