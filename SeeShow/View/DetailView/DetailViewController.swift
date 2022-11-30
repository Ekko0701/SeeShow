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
    
    var navigationBar = DetailNavigationBar()
    
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
    
    private var infoBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundWhite
        view.layer.applyBorder(color: .clear, radius: 14)
    
        return view
    }()
    
    /// 포스터 이미지 poster
    let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    /// 포스터 이미지에 alpha값을 적용할 view
    let posterImageCover: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroundWhite
        view.alpha = 0
        
        return view
    }()
    
    /// 공연 제목 prfnm
    let prfnmLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "지저스 크라이스트 수퍼스타 50주년 기념 한국 공연", style: .bold, size: 24, color: .black)
        label.lineBreakMode = .byWordWrapping
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
        label.applyNoToSansKR(text: "만 7세", style: .medium, size: 16, color: .black)
        label.backgroundColor = .backgroundGray
        label.clipsToBounds = true
        label.layer.applyBorder(color: .clear, radius: 4)
        return label
    }()
    
    let runningTimeLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "70분", style: .medium, size: 16, color: .black)
        label.backgroundColor = .backgroundGray
        label.clipsToBounds = true
        label.layer.applyBorder(color: .clear, radius: 4)
        return label
    }()
    
    /// 공연 기간 아이콘
    let fromToIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar.circle")
        imageView.tintColor = .black
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// 공연 기간 , 공연 시작일 prfpdfrom, 공연 마감일 prfpdto
    let prfpdfromToLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "2022.11.10 ~ 2023.01.15", style: .medium, size: 18, color: .black)
        return label
    }()
    
    /// 공연 시간 레이블
    let playtimeLabel: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "공연시간", style: .medium, size: 20, color: .black)
        
        label.backgroundColor = .backgroundGray
        label.layer.applyBorder(color: .backgroundGray, radius: 4)
        return label
    }()
    
    let playtime: UILabel = {
        let label = UILabel()
        label.applyNoToSansKR(text: "화요일 ~ 금요일(19:30), 토요일 ~ 일요일(14:00,18:30), HOL(14:00,18:30)", style: .medium, size: 18, color: .black)
        let text = label.text
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
        label.applyNoToSansKR(text: "광림아트센터 (BBCH홀)", style: .medium, size: 18, color: .black)
        label.numberOfLines = 1
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
        stackView.alignment = .leading
        stackView.distribution = .fill
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
        //stackView.alignment = .fill
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        stackView.layer.applyBorder(color: .backgroundGray, radius: 4)
        
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

    let defaultDetailPoster = DefaultDetailPosterView()
    
    /// SecondStack의 Bottom 제약조건
    var posterImageHeight: CGFloat = 500
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController - viewDidLoad()")
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = false
        
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        
        configureLayout()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("DetailViewController - viewWillAppear")
        tabBarController?.tabBar.isHidden = true
        configureNavBar()
    }
    
    private func configureNavBar() {
        self.navigationController?.navigationBar.isHidden = true
        
        navigationBar.navigationHeight = 45
        navigationBar.delegate = self
        
        navigationBar.backgroundColor = .white.withAlphaComponent(0)
    }
    
    func configureLayout() {
        // Add Subview
        view.addSubview(posterImage)
        view.addSubview(posterImageCover)
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        // Add SubView to ContentView
        contentView.addSubview(infoBoxView)
        
        // 0. Add Subview to 'BoxView'
        infoBoxView.addSubview(firstStack)
        infoBoxView.addSubview(secondStack)
        infoBoxView.addSubview(detailPosterStack)
        
        // 1. Add SubView to 'First' StackView
        
        locationStack.addArrangedSubview(placeIcon)
        locationStack.addArrangedSubview(placeLabel)
        
        fromToStack.addArrangedSubview(fromToIcon)
        fromToStack.addArrangedSubview(prfpdfromToLabel)
        
        firstStack.addArrangedSubview(prfnmLabel)
        firstStack.addArrangedSubview(ageLabel)
        firstStack.addArrangedSubview(runningTimeLabel)
        firstStack.addArrangedSubview(locationStack)
        firstStack.addArrangedSubview(fromToStack)
        
        // 2. Add Subview to 'Second' StackView
        secondStack.addArrangedSubview(playtimeLabel)
        secondStack.addArrangedSubview(playtime)
        
        // Autolayout
        navigationBar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(navigationBar.containerView)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            
            //make.top.equalTo(view)
            make.bottom.leading.trailing.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.centerX.equalTo(scrollView.snp.centerX)
            make.width.equalTo(scrollView.snp.width)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        posterImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(posterImageHeight)
        }
        
        posterImageCover.snp.makeConstraints { make in
            make.edges.equalTo(posterImage)
        }
        
        infoBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(contentView).offset(400)
            make.bottom.equalTo(contentView)
        }
        
        firstStack.snp.makeConstraints { make in
            make.top.equalTo(infoBoxView).offset(16)
            make.leading.equalTo(infoBoxView).offset(16)
            make.trailing.equalTo(infoBoxView).offset(-16)
        }
        
        secondStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(firstStack.snp.bottom).offset(8)

        }
        
        detailPosterStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(secondStack.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.snp.bottom)
        }
        
    }
    
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
                                              placeholder: ImagePlaceholderView(),
                                              completionHandler: { result in
                        switch result {
                        case.success(let imageResult):
                            let sizeWidth = imageResult.image.size.width
                            let sizeHeight = imageResult.image.size.height
                            
                            let viewWidth = self?.view.frame.width ?? 0
                            
                            let newWidth = viewWidth
                            let multiplier = viewWidth / sizeWidth
                            let newHeight = sizeHeight * multiplier
                            
                            let newSize: CGSize = CGSize(width: newWidth, height: newHeight)
                            let resized = imageResult.image.kf.resize(to: newSize, for: .aspectFill)
                            
                            self?.posterImageHeight = newHeight
                            self?.posterImage.image = resized
                            
                            // Update Constraints
                            self?.posterImage.snp.updateConstraints{ make in
                                make.height.equalTo(newSize.height)
                            }
                            
                            let window = UIApplication.shared.windows.first
                            let top = window?.safeAreaInsets.top
                            
                            self?.infoBoxView.snp.updateConstraints({ make in
                                make.top.equalTo(self!.contentView).offset(newSize.height - (self?.navigationBar.navigationHeight ?? 0) - (top ?? 0) - 16)
                                //make.top.equalTo(self!.contentView).offset(newSize.height)
                                                            
                            })
                        case .failure(let error):
                            print(error.localizedDescription)
                        }
                    })
                
            }).disposed(by: disposeBag)
        
        viewModel.prfnmText.bind(to: prfnmLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.fcltynmText.bind(to: placeLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.prfageText.bind(to: ageLabel.rx.text).disposed(by: disposeBag)

        viewModel.prfruntimeText.bind(to: runningTimeLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.prfpdFromToText.bind(to: prfpdfromToLabel.rx.text).disposed(by: disposeBag)
        
        viewModel.dtguidanceText.bind(to: playtime.rx.text).disposed(by: disposeBag)
        
        // 상세 포스터
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
                                
                                let newWidth = viewWidth
                                let multiplier = viewWidth / sizeWidth
                                let newHeight = sizeHeight * multiplier
                                
                                let newSize: CGSize = CGSize(width: newWidth, height: newHeight)
                                let resized = imageResult.image.kf.resize(to: newSize, for: .aspectFill)
                                
                                self?.detailPosterImage.image = resized
                                
                                guard let self = self else { return }
                                self.detailPosterStack.addArrangedSubview(self.detailPosterImage)
                                self.detailPosterStack.addArrangedSubview(self.defaultDetailPoster)
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        })
                    } else {
                        print("상세 포스터 없음 !!!!! ")
                        guard let self = self else { return }
                        self.detailPosterStack.addArrangedSubview(self.defaultDetailPoster)
                    }
                }
            }).disposed(by: disposeBag)
    }
}

//MARK: - ScrollView Delegate
extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y + scrollView.contentInset.top
        let postAlphaSpace = posterImageHeight - navigationBar.navigationHeight - 16
        print("오프셋: \(offsetY)")
        //print("공간: \(postAlphaSpace)") // 412.0
        posterImage.clipsToBounds = offsetY <= 0
        
        if offsetY < 0 {
            posterImage.snp.updateConstraints { make in
                make.height.equalTo(posterImageHeight - offsetY)
            }
            navigationBar.leftItem.tintColor = .backgroundWhite
            navigationBar.rightItem.tintColor = .backgroundWhite
        }
        if offsetY > 0 {
            posterImageCover.alpha = offsetY / postAlphaSpace - 0.3
            
            
            let navAlpha = offsetY / postAlphaSpace
            navigationBar.backgroundColor = .backgroundWhite.withAlphaComponent(navAlpha)
            
            if navAlpha > 0.5 {
                navigationBar.leftItem.tintColor = .black
                navigationBar.rightItem.tintColor = .black
            } else {
                navigationBar.leftItem.tintColor = .backgroundWhite
                navigationBar.rightItem.tintColor = .backgroundWhite
            }
        } else if offsetY > postAlphaSpace / 10 * 9 {
            posterImageCover.alpha = 1
        }
    }
    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//
//        let postAlphaSpace = (posterImageHeight - navigationBar.navigationHeight - 16)
//        let window = UIApplication.shared.windows.first
//        let top = window?.safeAreaInsets.top
//
//        if targetContentOffset.pointee.y > postAlphaSpace / 10 {
//            targetContentOffset.pointee.y = postAlphaSpace - navigationBar.navigationHeight - 16
//        }
//    }
}

//MARK: - Detail NavigationBar Protocol
extension DetailViewController: DetailNavigationBarProtocol {
    func touchBackButton() {
        print("backward")
        navigationController?.popViewController(animated: true)
    }
    
    func touchHomeButton() {
        print("homebutton")
        //navigationController?.popViewController(animated: true)
        //navigationController?.popViewController(animated: true)
        navigationController?.popToRootViewController(animated: true)
        tabBarController?.selectedIndex = 0
        print(navigationController?.viewControllers)
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
