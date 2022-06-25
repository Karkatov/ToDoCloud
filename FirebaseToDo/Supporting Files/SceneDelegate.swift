

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var tabBar: UITabBarController!
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        //TabBarController
        tabBar = createTabBarController()
        window.rootViewController = tabBar
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        tabBar = createTabBarController()
        window?.rootViewController = tabBar
    }
    
    func setOne() -> UINavigationController {
        let vc = UINavigationController(rootViewController: LoginViewController())
        
        vc.tabBarItem = UITabBarItem(title: "Заметки", image: UIImage(systemName: "bookmark.fill"), tag: 0)
        return vc
    }
    func setTwo() -> UINavigationController {
        let vc = UINavigationController(rootViewController: WeatherViewController())
        
        vc.tabBarItem = UITabBarItem(title: "Погода", image: UIImage(systemName: "sun.max.fill"), tag: 1)
        return vc
    }
    
    func setThree() -> UINavigationController {
        let vc = UINavigationController(rootViewController: ValuteViewController())
        vc.tabBarItem = UITabBarItem(title: "Курс", image: UIImage(systemName: "chart.bar.fill"), tag: 2)
        return vc
    }
    
    func createTabBarController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [setOne(), setTwo(), setThree()]
        return tabBarController
    }
}

