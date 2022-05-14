//
//  CoreAnimation.swift
//  Weather App
//
//  Created by Duxxless on 04.02.2022.
//

import UIKit

extension UIButton {
    func pulsate(_ fromValue: Double) {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1.2
        pulse.fromValue = fromValue
        pulse.toValue = 1
        pulse.initialVelocity = 0.5
        //pulse.autoreverses = true
        //pulse.repeatDuration = .greatestFiniteMagnitude
        //pulse.damping = 1
        layer.add(pulse, forKey: nil)
    }
    
    func opacityAnimation() {
        let opacityAn = CABasicAnimation(keyPath: "opacity")
        opacityAn.fromValue = 1
        opacityAn.toValue = 0.5
        opacityAn.duration = 0.1
        opacityAn.autoreverses = true
        layer.add(opacityAn, forKey: nil)
    }

    func shake() {
        let label = CABasicAnimation(keyPath: "position")
        label.fromValue = CGPoint(x: center.x - 5, y: center.y)
        label.toValue = CGPoint(x: center.x + 5, y: center.y)
        label.duration = 0.1
        layer.add(label, forKey: .none)
    }
}
