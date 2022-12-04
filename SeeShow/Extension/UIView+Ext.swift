//
//  UIView+Ext.swift
//  SeeShow
//
//  Created by Ekko on 2022/11/04.
//

import Foundation
import UIKit

#if DEBUG
import SwiftUI

extension UIView {
    private struct ViewRepresentable: UIViewRepresentable {
        let uiview: UIView
        
        func updateUIView(_ uiView: UIViewType, context: Context) {
            
        }
        
        func makeUIView(context: Context) -> some UIView {
            return uiview
        }
    }
    
    func getPreview() -> some View {
        ViewRepresentable(uiview: self)
    }
}

#endif

extension UIView {
    func animateShimmer() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        self.layer.addSublayer(gradientLayer)
        
        let animation = makeAnimationGroup()
        animation.beginTime = 0.0
        
        gradientLayer.add(animation, forKey: "backgroundColor")
    }
    
    func makeAnimationGroup(previousGroup: CAAnimationGroup? = nil) -> CAAnimationGroup {
        let animDuration: CFTimeInterval = 1.5
        
        let anim1 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim1.fromValue = UIColor.gradientLightGrey.cgColor
        anim1.toValue = UIColor.gradientDarkGrey.cgColor
        anim1.duration = animDuration
        anim1.beginTime = 0.0
        
        let anim2 = CABasicAnimation(keyPath: #keyPath(CAGradientLayer.backgroundColor))
        anim2.fromValue = UIColor.gradientDarkGrey.cgColor
        anim2.toValue = UIColor.gradientLightGrey.cgColor
        anim2.duration = animDuration
        anim2.beginTime = anim1.beginTime + anim1.duration
        
        let group = CAAnimationGroup()
        group.animations = [anim1, anim2]
        group.repeatCount = .greatestFiniteMagnitude
        group.duration = anim2.beginTime + anim2.duration
        group.isRemovedOnCompletion = false
        
        if let previousGroup = previousGroup {
            // Offset groups by 0.33 seconds for effect
            group.beginTime = previousGroup.beginTime + 0.33
        }
        
        return group
    }
}
