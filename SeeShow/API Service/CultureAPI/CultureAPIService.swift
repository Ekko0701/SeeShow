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
            "from" : String(20220101),
            "to" : String(20221124),
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
//                    print("success")
//
//                    var xml = XMLHash.parse(data)
//                    for elem in xml["response"]["msgBody"]["perforList"].all {
//                        print(elem["title"].element?.text ?? "알수없음")
//                        print(elem["gpsX"].element?.text ?? "0")
//                        print(elem["gpsY"].element?.text ?? "0")
//                    }
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
        return dateFormatter.string(from: date)
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
                    print("성공: \(data)")
                    var xml = XMLHash.parse(data)
                    for elem in xml["response"]["msgBody"]["perforInfo"].all {
                        print(elem["title"].element?.text ?? "알수없음")
                        print(elem["place"].element?.text ?? "메롱")
                    }
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
