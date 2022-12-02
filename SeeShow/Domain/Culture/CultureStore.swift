//
//  CultureStore.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/24.
//

import Foundation
import RxSwift
import SWXMLHash

protocol CultureFetchable {
    var gpsxfrom: Double { get set }
    var gpsyfrom: Double { get set }
    var gpsxto: Double { get set }
    var gpsyto: Double { get set }
    
    func fetchCultures() -> Observable<[CultureModel]>
}

class CultureStore: CultureFetchable {
    var gpsxfrom: Double = 0
    var gpsyfrom: Double = 0
    var gpsxto: Double = 0
    var gpsyto: Double = 0
    
    init(gpsxfrom: Double, gpsyfrom: Double, gpsxto: Double, gpsyto: Double) {
        self.gpsxfrom = gpsxfrom
        self.gpsyfrom = gpsyfrom
        self.gpsxto = gpsxto
        self.gpsyto = gpsyto
    }
    
    func fetchCultures() -> RxSwift.Observable<[CultureModel]> {
        return CultureAPIService.fetchWithGPS(gpsxfrom: gpsxfrom, gpsyfrom: gpsyfrom, gpsxto: gpsxto, gpsyto: gpsyto).map { data -> [CultureModel] in
            let xml = XMLHash.parse(data)
            do {
                let parsedData: [CultureModel] = try xml["response"]["msgBody"]["perforList"].value()
                print(parsedData)
                return parsedData
            }
            
        }
    }
    
    
}
