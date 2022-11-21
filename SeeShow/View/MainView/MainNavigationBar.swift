//
//  MainNavigationBar.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/21.
//

import Foundation
import SnapKit
import UIKit
import ChameleonFramework

protocol MainNavigationBarProtocol {
    func touchRightButton()
}

class MainNavigationBar: UIView {
    var delegate: MainNavigationBarProtocol?
    
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
    
    let leftItem: UIView = {
        let view = UIView()
        view.backgroundColor = .flatRed()
        
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "SeeShow", style: .bold, size: 24, color: .backgroundWhite)
        label.numberOfLines = 1
        
        return label
    }()
    
    let rightItem: UIButton = {
        let button = UIButton()
        let itemConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        let mapImage = UIImage(systemName: "map.circle", withConfiguration: itemConfiguration)
        button.setImage(mapImage, for: .normal)
        button.tintColor = .black
        
        button.addTarget(self, action: #selector(touchRightButton), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainNavigationBar {
    
    /// 레이아웃 설정
    func configureLayout() {
        // Add Subview
        self.addSubview(containerView)
        
        containerView.addSubview(leftItem)
        leftItem.addSubview(titleLabel)
        
        containerView.addSubview(rightItem)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        leftItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(8)
            make.trailing.bottom.equalToSuperview().offset(-8)
        }
        
        rightItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.width.equalTo(titleLabel.snp.height)
        }
    }
    
    @objc
    func touchRightButton() {
        guard let delegate = delegate else { return }
        delegate.touchRightButton()
    }
}
