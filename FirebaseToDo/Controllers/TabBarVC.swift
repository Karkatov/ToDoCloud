//
//  ExtensionTabBar.swift
//  FirebaseToDo
//
//  Created by Duxxless on 09.03.2022.
//

import UIKit

extension UITabBarController {

    func setMyHeightTabBar(tabBarController: UITabBarController) -> UITabBarController {
        tabBarController.tabBar.frame = CGRect(x: 20, y: view.frame.size.height - 85, width: view.frame.size.width - 40, height: 65)
        tabBarController.tabBar.backgroundColor = .systemGray4
        tabBarController.tabBar.layer.cornerRadius = 30
        tabBarController.tabBar.clipsToBounds = true
        
      
        return tabBarController
    }
}

