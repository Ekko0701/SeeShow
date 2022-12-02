//
//  MapBottomSheetViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/30.
//

import Foundation
import SnapKit
import ChameleonFramework

class BottomSheetView: UIView {
    
    private let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        return view
    }()
    
    var titleBehindView: UIView = {
        let view = UIView()
        
        return view
    }()
    
    var title: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "타이틀", style: .regular, size: 18, color: .black)
        label.numberOfLines = 0
        
        return label
    }()
    
    var place: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "", style: .regular, size: 14, color: .black)
        
        return label
    }()
    
    var thumbnail: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    var period: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "", style: .regular, size: 14, color: .black)
        
        return label
    }()
    
    var realmName: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "", style: .regular, size: 14, color: .black)
        
        label.layer.applyBorder(color: .clear, radius: 4)
        return label
    }()
    
    /// 공연 장소 아이콘
    let placeIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "location.circle")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 공연 기간 아이콘
    let fromToIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar.circle")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let infoStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    let locationStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 4
        return stackView
    }()
    
    let fromToStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .backgroundWhite
        configureStyle()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomSheetView {
    func configureStyle() {
        self.layer.cornerRadius = 14
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -10)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 14
    }
    
    func configureLayout() {
        // Add Subviews
        self.addSubview(thumbnail)
        self.addSubview(infoStack)
        
        // Stack
        infoStack.addArrangedSubview(titleBehindView)
        infoStack.addArrangedSubview(realmName)
        infoStack.addArrangedSubview(locationStack)
        infoStack.addArrangedSubview(fromToStack)
        
        //
        titleBehindView.addSubview(title)
        
        //
        locationStack.addArrangedSubview(placeIcon)
        locationStack.addArrangedSubview(place)
        
        //
        fromToStack.addArrangedSubview(fromToIcon)
        fromToStack.addArrangedSubview(period)
        
        // AutoLayout
        title.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        thumbnail.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(thumbnail.snp.height).multipliedBy(0.7)
        }
        
        infoStack.snp.makeConstraints { make in
            make.top.equalTo(thumbnail.snp.top)
            make.leading.equalTo(thumbnail.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
}
