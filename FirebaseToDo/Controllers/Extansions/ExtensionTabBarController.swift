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
        tabBar.layer.cornerRadius = 30
        tabBar.clipsToBounds = true
        tabBar.tintColor = UIColor(red: 5/255, green: 168/255, blue: 46/255, alpha: 1)
        tabBar.itemPositioning = .centered
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .white
        
        return tabBarController
    }
}

