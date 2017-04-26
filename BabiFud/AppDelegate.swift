

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    guard let tabBarController = window?.rootViewController as? UITabBarController,
      let splitViewController = tabBarController.viewControllers?.first as? UISplitViewController,
      let navigationController = splitViewController.viewControllers.last as? UINavigationController,
      let detailViewController = navigationController.topViewController as? DetailViewController else {
        return true
    }
    
    splitViewController.delegate = detailViewController
    return true
  }
}
