//
//  DetailViewModel.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa
import SWXMLHash
import RxDataSources

protocol DetailViewModelType {
    // INPUT
    var fetchDetails: AnyObserver<Void> { get }
    
    // OUTPUT
    var pushDetails: Observable<[ViewBoxOffice]> { get }
}

//class DetailViewModel: DetailViewModelType {
//    let fetchDetails: RxSwift.AnyObserver<Void>
//    
//    let pushDetails: RxSwift.Observable<[ViewBoxOffice]>
//    
//    
//}
