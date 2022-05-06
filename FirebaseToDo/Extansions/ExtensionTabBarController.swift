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
        
        if UIScreen.main.bounds.size.height < 670 {
            tabBar.frame = CGRect(x: 0, y: view.frame.size.height - 55, width: view.frame.size.width, height: 55)
        } else {
            tabBar.frame = CGRect(x: 20, y: view.frame.size.height - 90, width: view.frame.size.width - 40, height: 65)
            tabBar.layer.cornerRadius = 30
        }
        tabBar.clipsToBounds = true
        tabBar.tintColor = UIColor(red: 5/255, green: 168/255, blue: 46/255, alpha: 1)
        tabBar.isTranslucent = true
        tabBar.backgroundColor = .white
        return tabBarController
    }
}

