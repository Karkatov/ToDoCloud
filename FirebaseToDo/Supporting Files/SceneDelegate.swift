//
//  SceneDelegate.swift
//  FirebaseToDo
//
//  Created by Duxxless on 01.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        //TabBarController

        let tabBar = createTabBarController()
        
        window.rootViewController = tabBar
        
        self.window = window
        window.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    func setOne() -> UINavigationController {
            let vc = UINavigationController(rootViewController: ViewController())
            
            vc.tabBarItem = UITabBarItem(title: "Заметки", image: UIImage(systemName: "bookmark.fill"), tag: 0)
            return vc
        }
    func setTwo() -> UINavigationController {
            let vc = UINavigationController(rootViewController: WeatherVC())
            
            vc.tabBarItem = UITabBarItem(title: "Погода", image: UIImage(systemName: "sun.max.fill"), tag: 1)
            return vc
        }

    func setThree() -> UINavigationController {
        let vc = UINavigationController(rootViewController: ViewControllerValute())
        vc.title = "ViewController"
        
        vc.tabBarItem = UITabBarItem(title: "Курс", image: UIImage(systemName: "chart.bar.fill"), tag: 2)
        return vc
    }
    
    func setFour() -> UINavigationController {
        let vc = UINavigationController(rootViewController: TableViewController())
        
        vc.tabBarItem = UITabBarItem(title: "Курс", image: UIImage(systemName: "chart.bar.fill"), tag: 3)
        return vc
    }
    
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [setOne(), setTwo(), setThree()]
        return tabBarController
    }
}

