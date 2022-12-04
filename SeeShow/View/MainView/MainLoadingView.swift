//
//  SkeletonLoaderView.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/02.
//

import Foundation
import SnapKit
import UIKit

class MainLoadingView: UIView {
    let firstView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let secondView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let thirdView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let bannerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundGray
        
        return view
    }()
    
    let categoryView: UIView = {
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
        self.addSubview(secondView)
        self.addSubview(thirdView)
        self.addSubview(bannerView)
        self.addSubview(categoryView)
        
        firstView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        
        secondView.snp.makeConstraints { make in
            make.centerY.equalTo(firstView)
            make.height.equalTo(firstView).multipliedBy(0.5)
            make.width.equalTo(secondView.snp.height)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        thirdView.snp.makeConstraints { make in
            make.top.equalTo(firstView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(thirdView.snp.width).multipliedBy(0.1)
        }
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(thirdView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(bannerView.snp.width).multipliedBy(1.2)
        }
        
        categoryView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(categoryView.snp.width).multipliedBy(0.4)
        }
    }
}




//MARK: - Preview

#if DEBUG
import SwiftUI
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MainLoadingView().getPreview()
            //.ignoresSafeArea()
    }
}
/// option + command +enter -> 접었다 폈다
/// option + command + p -> 미리보기 실행
#endif
