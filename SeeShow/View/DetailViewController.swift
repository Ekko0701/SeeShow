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
import RxViewController
import Kingfisher

class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var viewModel: DetailViewModelType
    
    init(viewModel: DetailViewModelType = DetailViewModel()) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = .magenta
        view.alpha = 1
        
        return view
    }()
    
    /// 포스터 이미지 poster
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "test1")
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
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(systemName: "house")
        return imageView
    }()
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        //scrollView.backgroundColor = .brown
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
    
    /// SecondStack의 Bottom 제약조건
    var secondStackBottomConstraint = NSLayoutConstraint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad()")
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        configureTest()
        configureLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("DetailViewController - viewWillAppear")
    }
    
    func configureTest() {
        let url = URL(string: "http://www.kopis.or.kr/upload/pfmPoster/PF_PF198309_220919_094321.gif")
        posterImage.kf.indicatorType = .activity
        posterImage.kf.setImage(with: url)
        
        //        let detailPosterURL = URL(string: "http://www.kopis.or.kr/upload/pfmIntroImage/PF_PF198309_220919_0943210.jpg")
        //        detailPosterImage.kf.indicatorType = .activity
        ////        detailPosterImage.kf.setImage(with: detailPosterURL, options: [.scaleFactor(UIScreen.main.scale)])
        //        detailPosterImage.kf.setImage(with: detailPosterURL,options: [],progressBlock: {receivedSize, totalSize in
        //            print(" progressBlock = \(receivedSize) / \(totalSize)")
        //        },
        //        completionHandler: { result in
        //            print("결과 \(result)")
        //        })
        
        if let thumbnailURL = URL(string: "http://www.kopis.or.kr/upload/pfmIntroImage/PF_PF198309_220919_0943210.jpg") {
            KingfisherManager.shared.retrieveImage(with: thumbnailURL, completionHandler: { result in
                switch (result) {
                case .success(let imageResult):
                    let sizeWidth = imageResult.image.size.width
                    let sizeHeight = imageResult.image.size.height
                    
                    let viewWidth = self.view.frame.width
                    //let viewHeight = self.view.frame.height
                    
                    let newWidth = viewWidth
                    let multiplier = viewWidth / sizeWidth
                    let newHeight = sizeHeight * multiplier
                    
                    let newSize: CGSize = CGSize(width: newWidth, height: newHeight)
                    let resized = imageResult.image.kf.resize(to: newSize, for: .aspectFill)
                    
                    self.detailPosterImage.image = resized
                
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            })
        }
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
        //MARK: - !!!!!!! 주의 !!!!!!!!! 테스트중
        //detailPosterStack.addArrangedSubview(detailPosterImage)
        
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
        }
        
        secondStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().offset(8)
            make.top.equalTo(firstStack.snp.bottom).offset(8)
        }
        
        detailPosterImage.snp.makeConstraints { make in
            //make.height.equalTo(5000)
        }
        
        detailPosterStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(secondStack.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
    //MARK: - 바인딩 작업중
    func setupBindings() {
        // ------------------------------
        //  INPUT
        // ------------------------------
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in
                ()
            }
        
        firstLoad
            .bind(to: viewModel.fetchDetails)
            .disposed(by: disposeBag)
        
        // ------------------------------
        //  OUTPUT
        // ------------------------------
        
        // Loading View
        viewModel.activated
            .map { !$0 }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.pushDetails
            .map { URL(string: $0.poster) }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] url in
                self?.posterImage.kf.indicatorType = .activity
                self?.posterImage.kf.setImage(with: url,
                placeholder: ImagePlaceholderView())
            }).disposed(by: disposeBag)
        
        viewModel.prfnmText.bind(to: prfnmLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.fcltynmText.bind(to: placeLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.prfageText.bind(to: ageLabel.rx.text).disposed(by: disposeBag)

        viewModel.prfruntimeText.bind(to: runningTimeLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.prfpdFromToText.bind(to: prfpdfromToLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.dtguidanceText.bind(to: playtime.rx.text).disposed(by: disposeBag)
        
        viewModel.pushDetails
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { detail in
                _ = detail.styurls.map { [weak self] detailURLString in
                    if let detailURL = URL(string: detailURLString) {
                        KingfisherManager.shared.retrieveImage(with: detailURL, completionHandler: { result in
                            switch (result) {
                            case.success(let imageResult):
                                let sizeWidth = imageResult.image.size.width
                                let sizeHeight = imageResult.image.size.height
                                
                                let viewWidth = self?.view.frame.width ?? 0
                                //let viewHeight = self.view.frame.height
                                
                                let newWidth = viewWidth
                                let multiplier = viewWidth / sizeWidth
                                let newHeight = sizeHeight * multiplier
                                
                                let newSize: CGSize = CGSize(width: newWidth, height: newHeight)
                                let resized = imageResult.image.kf.resize(to: newSize, for: .aspectFill)
                                
                                self?.detailPosterImage.image = resized
                               
                                #warning("TODO : - self! 생각해보기..  순환참조 공부 필요 ")
                                self?.detailPosterStack.addArrangedSubview(self!.detailPosterImage)
                            case .failure(let error):
                                #warning("TODO : - viewModel error로 보내는 방법 ? ")
                                print(error.localizedDescription)
                            }
                            
                        })
                    } else {
                        #warning("TODO : detailPosterStack을 없애고, secondStack의 bottomConstraints를 추가해야함. 반대도 괜찮음. ")
                        self?.detailPosterStack.isHidden = true
                        print("상세 포스터 없음 !!!!! ")
                        
                    }
                }
            }).disposed(by: disposeBag)
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
