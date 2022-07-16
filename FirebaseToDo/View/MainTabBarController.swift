

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = true
        
        let loginViewController = LoginViewController()
        let weatherViewController = WeatherViewController()
        let valuteViewController = ValuteViewController()
        
        viewControllers = [
            generateNavigationController(rootViewController: loginViewController, title: "Заметки", imageString: "bookmark.fill"),
            generateNavigationController(rootViewController: weatherViewController, title: "Погода", imageString: "sun.max.fill"),
            generateNavigationController(rootViewController: valuteViewController, title: "Курс", imageString: "chart.bar.fill")]
    }

    func generateNavigationController(rootViewController: UIViewController, title: String, imageString: String) -> UINavigationController {
        let rootVC = UINavigationController(rootViewController: rootViewController)
        rootVC.tabBarItem = UITabBarItem(title: title, image: UIImage(systemName: imageString), tag: 0)
        return rootVC
    }
}

