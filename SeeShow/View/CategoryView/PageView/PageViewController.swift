//
//  PageViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/23.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxViewController

protocol PageViewControllerProtocol {
    func navigationBarHide(value: Bool)
}

class PageViewController: UIViewController {
    let tableView = UITableView()
    var viewModel: PageViewModelType
    var disposeBag = DisposeBag()
    
    var delegate: PageViewControllerProtocol?
    
    var loadingView = PageLoadingView()
    
    init(viewModel: PageViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        configureLayout()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("PageViewController - viewWillAppear()")
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        skeletonLoading()
    }
    
    private func skeletonLoading() {
        let loadingView = self.loadingView
        loadingView.firstView.animateShimmer()
        loadingView.firstTitleLabel.animateShimmer()
        loadingView.firstPlaceLabel.animateShimmer()
        loadingView.firstPeriodLabel.animateShimmer()
        
        loadingView.secondView.animateShimmer()
        loadingView.secondTitleLabel.animateShimmer()
        loadingView.secondPlaceLabel.animateShimmer()
        loadingView.secondPeriodLabel.animateShimmer()
        
        loadingView.thirdView.animateShimmer()
        loadingView.thirdTitleLabel.animateShimmer()
        loadingView.thirdPlaceLabel.animateShimmer()
        loadingView.thirdPeriodLabel.animateShimmer()
        
        loadingView.fourthView.animateShimmer()
        loadingView.fourthTitleLabel.animateShimmer()
        loadingView.fourthPlaceLabel.animateShimmer()
        loadingView.fourthPeriodLabel.animateShimmer()
    }
    
    private func configureTableView() {
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        tableView.backgroundColor = .backgroundGray
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // Register
        tableView.register(PageCell.self, forCellReuseIdentifier: PageCell.identifier)
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        view.addSubview(loadingView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        loadingView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupBinding() {
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in
                ()
            }
        
        firstLoad
            .bind(to: viewModel.fetchBoxOffices)
            .disposed(by: disposeBag)
        
        viewModel.pushSection
            .bind(to: tableView.rx.items(dataSource: viewModel.dataSource))
            .disposed(by: disposeBag)

        // Loading View
        viewModel.activated
            .map { !$0 }
            .bind(to: loadingView.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        // Touch Event, 화면전환
        tableView.rx.itemSelected.subscribe(onNext: {
            [weak self] indexPath in
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.viewModel.touchCell.onNext(indexPath)
            print(indexPath)
        }).disposed(by: disposeBag)
        
        viewModel.showDetailPage.subscribe(onNext: { [weak self] performanceID in
            let vc = DetailViewController()
            vc.viewModel = DetailViewModel(domain: DetailStore(id: performanceID))
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        ).disposed(by: disposeBag)
    }
}
extension PageViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        guard let delegate = delegate else { return }
        if offsetY > 170 * 3 {
            delegate.navigationBarHide(value: true)
        } else {
            delegate.navigationBarHide(value: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}
