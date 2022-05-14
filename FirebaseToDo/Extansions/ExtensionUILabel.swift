//
//  ExtensionUILabel.swift
//  Weather App
//
//  Created by Duxxless on 05.02.2022.
//

import UIKit

extension UILabel {
    
    func opacityAnimation(myDuration: Double) {
        let label = CABasicAnimation(keyPath: "opacity")
        label.fromValue = 0
        label.toValue = 1
        label.duration = 0.5
        label.fillMode = .forwards
        label.isRemovedOnCompletion = false
        layer.add(label, forKey: nil)
    }
}
