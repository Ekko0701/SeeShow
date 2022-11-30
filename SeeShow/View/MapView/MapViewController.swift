//
//  MapViewController.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import UIKit
import NMapsMap
import CoreLocation
import RxSwift

class MapViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    var mapView = NMFNaverMapView()
    //var locationManager = CLLocationManager()
    var locationManager = NMFLocationManager.sharedInstance()
    var viewModel = MapViewModel(domain: CultureStore(gpsxfrom: 126.9928786492578, gpsyfrom: 37.56678910750669, gpsxto: 127.0096156334598, gpsyto: 37.59549354642078))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController - viewDidLoad()")
        view.backgroundColor = .systemGreen
        
        locationManager?.add(self)
        
        configureMapView()
        configureStyle()
        configureLayout()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("MapViewController - viewWillAppear")
        configureNavBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        locationManager?.remove(self)
    }
    
    /// 네비게이션 설정
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    /// Naver Map 설정
    private func configureMapView() {
        mapView = NMFNaverMapView(frame: view.frame)
        mapView.mapView.positionMode = .normal
        mapView.showLocationButton = true
        
        // Attack Delegate
        mapView.mapView.addCameraDelegate(delegate: self)
        mapView.mapView.touchDelegate = self
        
        
        locationManager?.startUpdatingLocation()
    }
    
    /// 스타일 설정
    private func configureStyle() {
        
    }
    
    /// 레이아웃 설정
    private func configureLayout() {
        // Add Subviews
        view.addSubview(mapView)
    }
    
    private func setupBinding() {
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in
                ()
            }
        
        firstLoad.bind(to: viewModel.fetchCultures)
            .disposed(by: disposeBag)
    }

}

extension MapViewController: NMFLocationManagerDelegate {
    
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        
        let frameLatLng = mapView.projection.latlngBounds(fromViewBounds: self.view.frame)
        let swLng = frameLatLng.southWestLng
        let swLat = frameLatLng.southWestLat
        let neLng = frameLatLng.northEastLng
        let neLat = frameLatLng.northEastLat
        
        viewModel = MapViewModel(domain: CultureStore(gpsxfrom: swLng, gpsyfrom: swLat, gpsxto: neLng, gpsyto: neLat))
        
        viewModel.fetchCultures.onNext(())
        
        // 마커 추가 & 마커 터치 액션
        viewModel.pushMarkers.subscribe { markers in
            _ = markers.map { markers in
                markers.forEach { marker in
                    marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                        

                        return true
                    }
                    marker.mapView = mapView
                }
            }
        }.disposed(by: disposeBag)
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    /// 지도 터치 액션
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print("지도 탭")
    }
}
