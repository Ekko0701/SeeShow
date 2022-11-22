//
//  DetailNavigationBar.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/21.
//

import Foundation
import SnapKit
import UIKit

protocol DetailNavigationBarProtocol {
    func touchBackButton()
    func touchHomeButton()
}

class DetailNavigationBar: UIView {
    var delegate: DetailNavigationBarProtocol?
    
    var navigationHeight: CGFloat = 45 {
        willSet {
            self.containerView.snp.updateConstraints { make in
                make.height.equalTo(newValue)
            }
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundWhite.withAlphaComponent(0)
        
        return view
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundWhite
        view.alpha = 0
        
        return view
    }()
    
    let leftItem: UIButton = {
        let button = UIButton()
        let itemConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let backwardImage = UIImage(systemName: "chevron.backward", withConfiguration: itemConfiguration)
        
        button.setImage(backwardImage, for: .normal)
        button.tintColor = .backgroundWhite
        
        button.addTarget(self, action: #selector(touchBackButton), for: .touchUpInside)
        
        return button
    }()
    
    let rightItem: UIButton = {
        let button = UIButton()
        let itemConfiguration = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular)
        let backwardImage = UIImage(systemName: "house", withConfiguration: itemConfiguration)
        
        button.setImage(backwardImage, for: .normal)
        button.tintColor = .backgroundWhite
        
        button.addTarget(self, action: #selector(touchHomeButton), for: .touchUpInside)
        
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

extension DetailNavigationBar {
    func configureLayout() {
        // Add Subview
        self.addSubview(containerView)
        
        containerView.addSubview(backgroundView)
        containerView.addSubview(leftItem)
        containerView.addSubview(rightItem)
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(60)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(containerView)
        }
        
        leftItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            //make.top.equalToSuperview().offset(0)
            make.leading.equalToSuperview().offset(16)
        }
        
        rightItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            //make.top.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-16)
        }
    }
    
    @objc
    func touchBackButton() {
        guard let delegate = delegate else { return }
        delegate.touchBackButton()
    }
    
    @objc
    func touchHomeButton() {
        guard let delegate = delegate else { return }
        delegate.touchHomeButton()
    }
}
