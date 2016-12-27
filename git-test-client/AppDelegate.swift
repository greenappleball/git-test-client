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

    func manualInit() -> Bool {
        let tabController = UITabBarController()
        tabController.viewControllers = [
			SearchViewController(dataProvider: NetworkDataProvider()).makeTabInNavigationController(with: UIImage(named: "first")),
			PublicReposViewController(dataProvider: NetworkDataProvider()).makeTabInNavigationController(with: UIImage(named: "second")),
			FavoritesViewController(dataProvider: FavoritesDataProvider()).makeTabInNavigationController(with: UIImage(named: "second"))]

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return manualInit()
    }
}

