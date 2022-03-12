//
//  ExtensionTabBar.swift
//  FirebaseToDo
//
//  Created by Duxxless on 09.03.2022.
//

import UIKit

extension UITabBarController {

    func setMyTabBar(tabBarController: UITabBarController) -> UITabBarController {
        let tabBar = tabBarController.tabBar
        tabBar.frame = CGRect(x: 20, y: view.frame.size.height - 90, width: view.frame.size.width - 40, height: 65)
        tabBar.backgroundColor = UIColor(red: 100, green: 50, blue: 109, alpha: 1)
        tabBar.layer.cornerRadius = 30
        tabBar.clipsToBounds = true
        tabBar.tintColor = .systemRed
        tabBar.barTintColor = .white
        tabBar.isTranslucent = true
        return tabBarController
    }
}

