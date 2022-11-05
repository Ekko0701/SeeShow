//
//  DetailViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import Kingfisher

class DetailViewController: UIViewController {
    
    let testLabel: UILabel = {
        let label = UILabel()
        
        label.text = """
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Why do we use it?
It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).


Where does it come from?
Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32"
"""
        label.numberOfLines = 0
        return label
    }()
    
    /// 포스터 이미지 poster
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "test1")
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 공연 제목 prfnm
    let prfnmLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "지저스 크라이스트 수퍼스타 50주년 기념 한국 공연", style: .bold, size: 27, color: .black)
        label.numberOfLines = 0
        return label
    }()
    
    
    /// 공연중 여부 prfstate
    let stateLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "공연중", style: .medium, size: 25, color: .black)
        return label
    }()
    
    /// 공연 나이 제한 prfage
    let ageLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "만 7세 /", style: .medium, size: 16, color: .black)
        return label
    }()
    
    let runningTimeLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "70분", style: .medium, size: 16, color: .black)
        return label
    }()
    
    /// 공연 기간 아이콘
    let fromToIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 공연 기간 , 공연 시작일 prfpdfrom, 공연 마감일 prfpdto
    let prfpdfromToLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "2022.11.10 ~ 2023.01.15", style: .medium, size: 20, color: .black)
        return label
    }()
    
    /// 공연 시간 레이블
    let playtimeLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "공연시간", style: .medium, size: 24, color: .black)
        return label
    }()
    
    let playtime: UILabel = {
       let label = UILabel()
        label.applyNoToSansKR(text: "화요일 ~ 금요일(19:30), 토요일 ~ 일요일(14:00,18:30), HOL(14:00,18:30)", style: .medium, size: 20, color: .black)
        label.numberOfLines = 0
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
    
    /// 공연 장소 entrpsnm
    let placeLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "광림아트센터 (BBCH홀)", style: .medium, size: 20, color: .black)
        return label
    }()
    
    /// 티켓 가격
    let ticketPriceLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "가격", style: .medium, size: 20, color: .black)
        return label
    }()
    
    /// 공연 상세 포스터
    let detailPosterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "house")
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .brown
        return scrollView
    }()
    
    /// ScorllView의 ContentView
    let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    /// 공연명, 공연장, 기간
    let firstStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
    
    /// 러닝타임, 나이제한
    let detailStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = -270
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
    
    /// 공연 시간
    let secondStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView

    }()
    
    let detailPosterStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 16
        return stackView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad()")
        view.backgroundColor = .darkGray
        self.navigationController?.isNavigationBarHidden = false
        
        configureTest()
        configureLayout()
    }
    
    func configureTest() {
        let url = URL(string: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF198309_220919_094321.gif")
        posterImage.kf.indicatorType = .activity
        posterImage.kf.setImage(with: url)
        
        let detailPosterURL = URL(string: "http://www.kopis.or.kr/upload/pfmIntroImage/PF_PF198309_220919_0943210.jpg")
        detailPosterImage.kf.indicatorType = .activity
        detailPosterImage.kf.setImage(with: detailPosterURL)
    }
    
    func configureLayout() {
        // Add Subview
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add SubView to ContentView
        contentView.addSubview(posterImage)
        contentView.addSubview(firstStack) // 1
        contentView.addSubview(secondStack) // 2
        contentView.addSubview(detailPosterStack) // 3
        
        // 1. Add SubView to First StackView
        
        detailStack.addArrangedSubview(ageLabel)
        detailStack.addArrangedSubview(runningTimeLabel)
        
        locationStack.addArrangedSubview(placeIcon)
        locationStack.addArrangedSubview(placeLabel)
        
        fromToStack.addArrangedSubview(fromToIcon)
        fromToStack.addArrangedSubview(prfpdfromToLabel)
    
        firstStack.addArrangedSubview(prfnmLabel)
        firstStack.addArrangedSubview(detailStack)
        firstStack.addArrangedSubview(locationStack)
        firstStack.addArrangedSubview(fromToStack)
        
        // 2. Add Subview to Second StackView
        secondStack.addArrangedSubview(playtimeLabel)
        secondStack.addArrangedSubview(playtime)
        
        // 3. Add Subview to Detail
        detailPosterStack.addArrangedSubview(detailPosterImage)
        
        // Autolayout
        scrollView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        posterImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        firstStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(8)
            make.top.equalTo(posterImage.snp.bottom)
            //make.bottom.equalToSuperview()
            //make.bottom.equalTo(secondStack.snp.top)
        }
        
        secondStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(8)
            make.top.equalTo(firstStack.snp.bottom).offset(8)
            //make.bottom.equalTo(contentView.snp.bottom)
        }
        
        detailPosterStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.top.equalTo(secondStack.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
        
        
        
    }
    
    //MARK: - 작업중
    func configure(data: Int, data2: Observable<ViewBoxOffice> ) {
        //testLabel.text = data.description
        print(data)
        //testLabel.text = data.description
        
        data2.map { $0.mt20id }.subscribe(onNext: {
            print($0.description)
        }).disposed(by: DisposeBag())
    }
}

//MARK: - Preview

#if DEBUG
import SwiftUI
struct DetailViewController_Previews: PreviewProvider {
    static var previews: some View {
        DetailViewController().getPreview()
            .ignoresSafeArea()
    }
}
/// option + command +enter -> 접었다 폈다
/// option + command + p -> 미리보기 실행
#endif
