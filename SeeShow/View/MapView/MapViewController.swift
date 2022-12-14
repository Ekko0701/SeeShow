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
import SnapKit
import ChameleonFramework
import Kingfisher

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var disposeBag = DisposeBag()
    
    var mapView = NMFNaverMapView()
    
    private var locationButton: NMFLocationButton!
    
    var locationManager: CLLocationManager!
    
    var lat: Double?
    var long: Double?
    
    var viewModel = MapViewModel(domain: CultureStore(gpsxfrom: 126.9928786492578, gpsyfrom: 37.56678910750669, gpsxto: 127.0096156334598, gpsyto: 37.59549354642078))
    
    let bottomSheet = BottomSheetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MapViewController - viewDidLoad()")
        view.backgroundColor = .systemGreen
        
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
    }
    
    /// 네비게이션 설정
    private func configureNavBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    /// Naver Map 설정
    private func configureMapView() {
        mapView = NMFNaverMapView(frame: view.frame)
        mapView.mapView.positionMode = .normal
        mapView.showLocationButton = false
        
        locationButton = NMFLocationButton()
        locationButton.mapView = mapView.mapView // 새로 만든 locationButton 삽입
        
        // Attack Delegate
        mapView.mapView.addCameraDelegate(delegate: self)
        mapView.mapView.touchDelegate = self
        
        mapView.mapView.positionMode = .direction
        
        // Current 위치
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        switch locationManager.authorizationStatus {
        case .denied:
            print("거부")
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let space = locationManager.location?.coordinate
        lat = space?.latitude
        long = space?.longitude
    }
    
    
    
    /// 스타일 설정
    private func configureStyle() {
        
    }
    
    /// 레이아웃 설정
    private func configureLayout() {
        // Add Subviews
        view.addSubview(mapView)
        view.addSubview(bottomSheet)
        view.addSubview(locationButton)
        
        // AutoLayout
        bottomSheet.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(170)
        }
        
        bottomSheet.isHidden = true // 초기 숨김 상태
        
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
        
    
    }
    
    private func setupBinding() {
        let firstLoad = rx.viewWillAppear
            .take(1)
            .map { _ in
                ()
            }
        
        // Error
        viewModel.errorMessage
            .map { $0.domain }
            .subscribe(onNext: { [weak self] message in
                //self?.showAlert("Network Error", message)
                print(message)
            }).disposed(by: disposeBag)
        
        firstLoad.bind(to: viewModel.fetchCultures)
            .disposed(by: disposeBag)
        
        let bottomSheetViewModel = BottomSheetViewModel(domain: CultureDetailStore(seq: "207347"))
        firstLoad.bind(to: bottomSheetViewModel.fetchCultureDetail)
            .disposed(by: disposeBag)
    }
    
   

}

extension MapViewController: NMFLocationManagerDelegate {
    
}

extension MapViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
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
                    marker.marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                        
                        self?.bottomSheet.isHidden = false
                        
                        self?.bottomSheet.title.text = marker.title
                        self?.bottomSheet.place.text = marker.place
                        
                        self?.bottomSheet.period.text = marker.period
                        
                        self?.bottomSheet.realmName.text = marker.realmName
                        
                        self?.bottomSheet.thumbnail.kf.indicatorType = .activity
                        self?.bottomSheet.thumbnail.kf.setImage(with: URL(string: marker.thumbnail), placeholder: ImagePlaceholderView()) { result in
                            switch result {
                            case .success(let value):
                                let themeColor = AverageColorFromImage(value.image)
                                self?.bottomSheet.realmName.backgroundColor = themeColor
                                self?.bottomSheet.realmName.textColor = ContrastColorOf(themeColor, returnFlat: true)
                                self?.bottomSheet.realmName.layer.masksToBounds = true
                                self?.bottomSheet.realmName.layer.cornerRadius = 4
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                        
                        // locationButton 위치 조절
                        self?.updateLocationButtonLayout()
                        
                        return true
                    }
                    marker.marker.mapView = mapView
                }
            }
        }.disposed(by: disposeBag)
    }
    
    func updateLocationButtonLayout() {
        locationButton.snp.removeConstraints()
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(bottomSheet.snp.top).offset(-8)
        }
    }
}

extension MapViewController: NMFMapViewTouchDelegate {
    /// 지도 터치 액션
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        bottomSheet.isHidden = true
        locationButton.snp.removeConstraints()
        locationButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
        }
    }
}

//MARK: - Preview

#if DEBUG
import SwiftUI
struct MapViewController_Previews: PreviewProvider {
    static var previews: some View {
        MapViewController().getPreview()
            .ignoresSafeArea()
    }
}
/// option + command +enter -> 접었다 폈다
/// option + command + p -> 미리보기 실행
#endif
