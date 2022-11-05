//
//  DetailViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit
import RxSwift
import RxRelay
import RxCocoa
import SWXMLHash
import RxDataSources

protocol DetailViewModelType {
    // INPUT
    var fetchBoxOffices: AnyObserver<Void> { get }
    var fetchKidsBoxOffices: AnyObserver<Void> { get }
    
    // OUTPUT
    var allBoxOffices: Observable<[ViewBoxOffice]> { get }
    var pushKidsBoxOffices: Observable<[ViewBoxOffice]> { get }
    var activated: Observable<Bool> { get }
}
