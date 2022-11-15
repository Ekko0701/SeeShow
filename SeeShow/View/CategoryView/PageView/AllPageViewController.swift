//
//  AllBoxOfficePageViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/15.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxViewController

class AllPageViewController: UIViewController {
    let tableView = UITableView()
    var viewModel: PageViewModelType
    var disposeBag = DisposeBag()
    
    init(viewModel: PageViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
        configureTableView()
        configureLayout()
        setupBinding()
    }
    
    private func configureTableView() {
        
        // Register
        tableView.register(PageCell.self, forCellReuseIdentifier: PageCell.identifier)
    }
    
    private func configureLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
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

    }
}
