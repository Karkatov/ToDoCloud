

import UIKit

extension UIImageView {
    func pulsateImage() {
        let imageView = CABasicAnimation(keyPath: "opacity")
        imageView.fromValue = 0
        imageView.toValue = 1
        imageView.duration = 0.3
        imageView.fillMode = .forwards
        imageView.isRemovedOnCompletion = false
        layer.add(imageView, forKey: nil)
    }
}
