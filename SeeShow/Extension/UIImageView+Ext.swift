//
//  UIImageView+Ext.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit
import Kingfisher

extension UIImageView {
    
    /// Kingfisher Cache를 이용해 UIImageView에 Image 세팅
    func setImage(with urlString: String) {
        let cache = ImageCache.default
        cache.retrieveImage(forKey: urlString, options: nil) { result in // 캐시에서 Key(url)를 통해 이미지를 가져온다.
            switch result {
            case .success(let value):
                if let image = value.image { // 캐시에 이미지가 존재하는 경우
                    self.image = image
                } else {
                    guard let url = URL(string: urlString) else { return }
                    let resource = ImageResource(downloadURL: url, cacheKey: urlString)
                    self.kf.indicatorType = .activity // 인디케이터 표시
                    self.kf.setImage(with: resource)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
