//
//  AppDelegate.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func navigationControllerWithRootController(_ controller: UIViewController, with tabBarItem: UITabBarItem) -> UINavigationController {
        let nc = UINavigationController(rootViewController: controller)
        nc.tabBarItem = tabBarItem
        return nc
    }
    func searchController() -> UINavigationController {
        let controller = FirstViewController(dataProvider: NetworkDataProvider())
        controller.title = "Search"
        return navigationControllerWithRootController(controller, with: UITabBarItem(title: controller.title, image: UIImage(named: "first"), selectedImage: nil))
    }

    func repositoriesController() -> UINavigationController {
        let controller = RootViewController(dataProvider: NetworkDataProvider())
        controller.title = "Repositories"
        return navigationControllerWithRootController(controller, with: UITabBarItem(title: controller.title, image: UIImage(named: "second"), selectedImage: nil))
    }

    func favoritesController() -> UINavigationController {
        let controller = FavoritesViewController(dataProvider: FavoritesDataProvider())
        controller.title = "Favorites"
        return navigationControllerWithRootController(controller, with: UITabBarItem(title: controller.title, image: UIImage(named: "second"), selectedImage: nil))
    }

    func manualInit() -> Bool {
        let searchController = self.searchController()
        let repositoriesController = self.repositoriesController()
        let favoritesController = self.favoritesController()

        let tabController = UITabBarController()
        tabController.viewControllers = [searchController, repositoriesController, favoritesController]
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return manualInit()
    }


}

