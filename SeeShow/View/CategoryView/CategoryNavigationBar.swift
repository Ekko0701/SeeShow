//
//  CategoryNavigationBar.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/24.
//

import Foundation
import SnapKit
import UIKit
import ChameleonFramework

protocol CategoryNavigationBarProtocol {
}

class CategoryNavigationBar: UIView {
    var delegate: CategoryNavigationBarProtocol?
    
    var navigationHeight: CGFloat = 60 {
        willSet {
            self.containerView.snp.updateConstraints { make in
                make.height.equalTo(newValue)
            }
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundWhite
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "카테코리별 순위", style: .bold, size: 20, color: .black)
        label.numberOfLines = 1
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryNavigationBar {
    
    /// 레이아웃 설정
    func configureLayout() {
        // Add Subview
        self.addSubview(containerView)
        containerView.addSubview(titleLabel)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
        }
        
    }
}
