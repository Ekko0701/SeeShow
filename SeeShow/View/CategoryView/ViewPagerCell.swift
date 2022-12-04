//
//  ViewPagerCell.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/15.
//

import Foundation
import SnapKit
import UIKit
import RxSwift

/// CategoryViewController의 ViewPager UICollectionViewCell
class ViewPagerCell: UICollectionViewCell {
    static let identifier = "ViewPagerCell"
    
    var disposeBag = DisposeBag()
    
    private let pageTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.applyNoToSansKR(style: .medium, size: 20, color: .black)
        
        return label
    }()
    
    let touchingView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0)
        
        return view
    }()
    
    private let underBar: UIView = {
        let view = UIView()
        view.backgroundColor = .flatRed()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        configureStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.underBar.layoutIfNeeded()
                self.underBar.alpha = self.isSelected ?  1 : 0
            }, completion: nil)
        }
    }
    
    override func prepareForReuse() {
        isSelected = false
        disposeBag = DisposeBag()
    }
    
    private func configureLayout() {
        // Add Subview
        contentView.addSubview(touchingView)
        contentView.addSubview(pageTitle)
        contentView.addSubview(underBar)
        
        // Constraint
        touchingView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        pageTitle.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        underBar.snp.makeConstraints { make in
            make.bottom.equalTo(pageTitle.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
        }
    }
    
    private func configureStyle() {
        backgroundColor = .backgroundWhite
        underBar.alpha = 0
    }
    
    func configure(data: CategoryModel) {
        pageTitle.text = data.title
    }
    
}
