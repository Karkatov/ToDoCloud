//
//  ExtensionTabBar.swift
//  FirebaseToDo
//
//  Created by Duxxless on 09.03.2022.
//

import UIKit

extension UITabBar {

    override public func sizeThatFits(_ size: CGSize) -> CGSize {
    super.sizeThatFits(size)
    var sizeThatFits = super.sizeThatFits(size)
    sizeThatFits.height = 30 // or whatever height you need
    return sizeThatFits
   }
}
