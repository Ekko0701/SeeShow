//
//  ViewCulture.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/24.
//

import Foundation

struct ViewCulture {
    var title: String
    var startDate: String
    var endDate: String
    var place: String
    var realmName: String
    var thumbnail: String
    var gpsX: String
    var gpsY: String
    
    init(_ item: CultureModel) {
        self.title = item.title ?? "Empty"
        self.startDate = item.startDate ?? "Empty"
        self.endDate = item.endDate ?? "Empty"
        self.place = item.place ?? "Empty"
        self.realmName = item.realmName ?? "Empty"
        self.thumbnail = item.thumbnail ?? "Empty"
        self.gpsX = item.gpsX ?? "Empty"
        self.gpsY = item.gpsY ?? "Empty"
    }
}
