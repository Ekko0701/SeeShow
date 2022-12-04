//
//  PageLoadingView.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/03.
//

import Foundation
import SnapKit
import UIKit

class PageLoadingView: UIView {
    let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let firstTitleLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
        
    }()
    
    let firstPlaceLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let firstPeriodLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let secondTitleLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
        
    }()
    
    let secondPlaceLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let secondPeriodLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let thirdView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let thirdTitleLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
        
    }()
    
    let thirdPlaceLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let thirdPeriodLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let fourthView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let fourthTitleLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
        
    }()
    
    let fourthPlaceLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let fourthPeriodLabel: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .backgroundWhite
        configureLayout()
        firstView.animateShimmer()
        secondView.animateShimmer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - configure
    func configureLayout()  {
        
        self.addSubview(firstView)
        self.addSubview(firstTitleLabel)
        self.addSubview(firstPlaceLabel)
        self.addSubview(firstPeriodLabel)
        
        self.addSubview(secondView)
        self.addSubview(secondTitleLabel)
        self.addSubview(secondPlaceLabel)
        self.addSubview(secondPeriodLabel)
        
        self.addSubview(thirdView)
        self.addSubview(thirdTitleLabel)
        self.addSubview(thirdPlaceLabel)
        self.addSubview(thirdPeriodLabel)
        
        self.addSubview(fourthView)
        self.addSubview(fourthTitleLabel)
        self.addSubview(fourthPlaceLabel)
        self.addSubview(fourthPeriodLabel)
        
        // first
        firstView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(8)
            make.width.equalToSuperview().multipliedBy(0.27)
            make.height.equalTo(firstView.snp.width).multipliedBy(1.3)
        }
        
        firstTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(firstView)
            make.leading.equalTo(firstView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(firstView.snp.height).multipliedBy(0.15)
        }
        
        firstPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(firstTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(firstView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-48)
            make.height.equalTo(firstView.snp.height).multipliedBy(0.15)
        }
        
        firstPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(firstPlaceLabel.snp.bottom).offset(8)
            make.leading.equalTo(firstView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-56)
            make.height.equalTo(firstView.snp.height).multipliedBy(0.15)
        }
        
        // second
        secondView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(8)
            make.width.equalToSuperview().multipliedBy(0.27)
            make.height.equalTo(firstView.snp.width).multipliedBy(1.3)
        }
        
        secondTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(secondView)
            make.leading.equalTo(secondView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(secondView.snp.height).multipliedBy(0.15)
        }
        
        secondPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(secondTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(secondView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-48)
            make.height.equalTo(secondView.snp.height).multipliedBy(0.15)
        }
        
        secondPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(secondPlaceLabel.snp.bottom).offset(8)
            make.leading.equalTo(secondView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-56)
            make.height.equalTo(secondView.snp.height).multipliedBy(0.15)
        }
        
        // third
        thirdView.snp.makeConstraints { make in
            make.top.equalTo(secondView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(8)
            make.width.equalToSuperview().multipliedBy(0.27)
            make.height.equalTo(firstView.snp.width).multipliedBy(1.3)
        }
        
        thirdTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdView)
            make.leading.equalTo(thirdView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(thirdView.snp.height).multipliedBy(0.15)
        }
        
        thirdPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(thirdView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-48)
            make.height.equalTo(thirdView.snp.height).multipliedBy(0.15)
        }
        
        thirdPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(thirdPlaceLabel.snp.bottom).offset(8)
            make.leading.equalTo(thirdView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-56)
            make.height.equalTo(thirdView.snp.height).multipliedBy(0.15)
        }
        
        // fourth
        fourthView.snp.makeConstraints { make in
            make.top.equalTo(thirdView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(8)
            make.width.equalToSuperview().multipliedBy(0.27)
            make.height.equalTo(thirdView.snp.width).multipliedBy(1.3)
        }
        
        fourthTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthView)
            make.leading.equalTo(fourthView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-32)
            make.height.equalTo(fourthView.snp.height).multipliedBy(0.15)
        }
        
        fourthPlaceLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthTitleLabel.snp.bottom).offset(8)
            make.leading.equalTo(fourthView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-48)
            make.height.equalTo(fourthView.snp.height).multipliedBy(0.15)
        }
        
        fourthPeriodLabel.snp.makeConstraints { make in
            make.top.equalTo(fourthPlaceLabel.snp.bottom).offset(8)
            make.leading.equalTo(fourthView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-56)
            make.height.equalTo(fourthView.snp.height).multipliedBy(0.15)
        }
    }
}




//MARK: - Preview

#if DEBUG
import SwiftUI
struct PageLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        PageLoadingView().getPreview()
            //.ignoresSafeArea()
    }
}
/// option + command +enter -> 접었다 폈다
/// option + command + p -> 미리보기 실행
#endif

