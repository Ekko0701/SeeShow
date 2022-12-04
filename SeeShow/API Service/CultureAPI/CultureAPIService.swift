//
//  CultureAPIService.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/24.
//

import Foundation
import Alamofire
import RxSwift
import SWXMLHash

class CultureAPIService {
    
    static func fetchWithGPS(gpsxfrom: Double, gpsyfrom: Double, gpsxto: Double, gpsyto: Double) -> Observable<Data> {
        let parameters: Parameters = [
            "from" : dateToString(date: Date()),
            "to" : dateToString(date: getDateTo()),
            "place" : "1",
            "gpsxfrom" : String(gpsxfrom),
            "gpsyfrom" : String(gpsyfrom),
            "gpsxto" : String(gpsxto),
            "gpsyto": String(gpsyto),
            "cPage": "1",
            "rows": "30",
            "sortStdr": "1"
        ]
        
        return Observable.create { observer in
            _ = AF.request(CULTURE_API.BASE_URL,
                           method: .get,
                           parameters: parameters)
            .responseData { response in
                print("response")
                switch response.result {
                case .success(let data):
                  observer.onNext(data)
                    
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    
    static func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    
    static func getDateTo() -> Date {
        let dateFrom = Date()
        let dateTo = Calendar.current.date(byAdding: .month, value: 2, to: dateFrom) ?? dateFrom
        return dateTo
    }
    
    static func fetchCultureDetail(seq: String) -> Observable<Data> {
        let parameters: Parameters = [
            "seq": seq
        ]
        
        return Observable.create { observer in
            _ = AF.request(CULTURE_API.DETAIL_URL,
                           method: .get,
                           parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
        
    }
}
