//
//  Map.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/24.
//

import Foundation
import RxSwift
import RxRelay
import NMapsMap

protocol MapViewModelType {
    // INPUT
    var fetchCultures: AnyObserver<Void> { get }
    
    var touchMarker: PublishSubject<Void> { get }
    
    // OUTPUT
    var pushCultures: PublishRelay<[ViewCulture]> { get }
    var pushMarkers: PublishRelay<[MapMarkerModel]> { get }
    var activated: Observable<Bool> { get }
    
}

class MapViewModel: MapViewModelType {
    
    let disposeBag = DisposeBag()
    
    // ---------------------------
    // INPUT
    //----------------------------
    var fetchCultures: AnyObserver<Void>
    
    var touchMarker: PublishSubject<Void>
    
    //----------------------------
    // OUTPUT
    //----------------------------
    var pushCultures: PublishRelay<[ViewCulture]>
    var pushMarkers: PublishRelay<[MapMarkerModel]>
    var activated: Observable<Bool>
    
    init(domain: CultureFetchable = CultureStore(gpsxfrom: 0, gpsyfrom: 0, gpsxto: 0, gpsyto: 0)) {
        
        let fetching = PublishSubject<Void>()
        let activating = BehaviorSubject<Bool>(value: false)
        let error = PublishSubject<Error>()
        
        let touching = PublishSubject<Void>()
        
        let cultures = PublishRelay<[ViewCulture]>()
        let markers = PublishRelay<[MapMarkerModel]>()
        
        fetchCultures = fetching.asObserver()
        
        fetching
            .do(onNext: { _ in activating.onNext(true) })
            .flatMap(domain.fetchCultures)
            .map { $0.map { ViewCulture($0) }}
            .do(onNext: { _ in activating.onNext(false) })
                .subscribe(onNext: cultures.accept)
                .disposed(by: disposeBag)
        
        cultures.map { array in
            var markers: [MapMarkerModel] = []
            array.forEach { viewCulture in
                
                let gpsX = Double(viewCulture.gpsX)
                let gpsY = Double(viewCulture.gpsY)
                
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: gpsY ?? 0, lng: gpsX ?? 0)
                
                marker.iconImage = NMF_MARKER_IMAGE_BLACK
                marker.iconTintColor = UIColor.flatRed()
                
                markers.append(MapMarkerModel(marker: marker, seq: viewCulture.seq, thumbnail: viewCulture.thumbnail, title: viewCulture.title, place: viewCulture.place, period: viewCulture.startDate + "~" + viewCulture.endDate, realmName: viewCulture.realmName))
            }
            return markers
        }
        .subscribe(onNext: markers.accept)
        .disposed(by: disposeBag)
        
        touchMarker = touching.asObserver()
        
        // OUTPUT
        pushCultures = cultures
        pushMarkers = markers
        activated = activating.distinctUntilChanged()
    }
}
