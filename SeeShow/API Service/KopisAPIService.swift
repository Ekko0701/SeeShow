//
//  KopisAPIService.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/01.
//

import Foundation
import Alamofire
import RxSwift

/// Kopis API Serivces
class KopisAPIService {

    /// 전체 박스오피스 목록 요청 -> Observable<Data>
    static func fetchAllBoxOffice() -> Observable<Data> {
        let parameters: Parameters = [
            "service" : "a848d37955ab4ade9eba0a398af255e2",
            "ststype" : "week",
            "date" : "20221025"
        ]
        return Observable.create { observer in
            _ = AF.request("http://kopis.or.kr/openApi/restful/boxoffice", method: .get, parameters: parameters)
                .responseData { response in
                    print("response")
                    switch response.result {
                    case .success(let data):
                        print("sucess")
                        observer.onNext(data)
                        //observer.onCompleted()
                    case .failure(let error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }
    
    /// Kids 박스오피스 목록 요청 -> Observable<Data>
    static func fetchKidsBoxOffice() -> Observable<Data> {
        let parameters: Parameters = [
            "service" : "a848d37955ab4ade9eba0a398af255e2",
            "ststype" : "week",
            "date" : "20221025",
            "catecode" : "KID"
        ]
        return Observable.create { observer in
            _ = AF.request("http://kopis.or.kr/openApi/restful/boxoffice", method: .get, parameters: parameters)
                .responseData { response in
                    print("response")
                    switch response.result {
                    case .success(let data):
                        print("sucess")
                        observer.onNext(data)
                    case .failure(let error):
                        observer.onError(error)
                    }
                    observer.onCompleted()
                }
            return Disposables.create()
        }
    }
    ///http://www.kopis.or.kr/openApi/restful/pblprfr/PF198309?service=a848d37955ab4ade9eba0a398af255e2
    static func fetchPrfrDetail(id: String) -> Observable<Data> {
        let parameters: Parameters = [
            "service" : "a848d37955ab4ade9eba0a398af255e2",
        ]
        
        return Observable.create { observer in
            _ = AF.request("http://www.kopis.or.kr/openApi/restful/pblprfr/" + id, method: .get, parameters: parameters).responseData { response in
                print("response")
                switch response.result {
                case .success(let data):
                    print("fetchPrfrDetail - success \(data)")
                    observer.onNext(data)
                case .failure(let error):
                    print("fetchPrfrDetail - failure \(error.localizedDescription)")
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }

}
