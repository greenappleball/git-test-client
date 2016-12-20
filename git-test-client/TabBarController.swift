//
//  TabBarController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/16/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

enum Tabs: Int {
    case search = 1001
    case common
    case favorite
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var publicDataSource = DataSource(dataProvider: NetworkDataProvider())
    var favoritesDataSource = DataSource(dataProvider: DataProvider())

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func performInit(dataSource: DataSource, for viewController: UIViewController) {
        if let nv: UINavigationController = viewController as? UINavigationController {
            if let vc: RootViewController = nv.topViewController as? RootViewController {
                guard (vc.dataSource != nil) else {
                    vc.dataSource = dataSource
                    vc.load()
                    return
                }
            }
        }
    }

    // UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tag = tabBarController.tabBar.selectedItem?.tag else {
            return
        }

        if let tab: Tabs = Tabs(rawValue: tag) {
            switch tab {
            case .common:
                performInit(dataSource: publicDataSource, for: viewController)
            case .favorite:
                performInit(dataSource: favoritesDataSource, for: viewController)
            default:
                return
            }
        }
    }
}
