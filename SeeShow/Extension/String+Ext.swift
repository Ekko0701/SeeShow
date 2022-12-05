//
//  UIString+Ext.swift
//  SeeShow
//
//  Created by Ekko on 2022/12/05.
//

import Foundation

extension String {
    func stringToDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        print("확인 \(dateFormatter.date(from: self))")
        if let date = dateFormatter.date(from: self) {
           let secondFormatter = DateFormatter()
            secondFormatter.dateFormat = "yyyy년 MM월 dd일"
            return secondFormatter.string(from: date)
        } else {
            return self
        }
    }
}
