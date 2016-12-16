//
//  TabBarController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/16/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

enum Tabs: Int {
    case not_interesting = 0
    case search = 1001
    case public_repositories
    case favorite_repositories
}

class TabBarController: UITabBarController, UITabBarControllerDelegate {

    var publicDataSource = DataSource(type: .repos_public)
    var favoritesDataSource = DataSource(type: .repos_favorites)

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
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
        let tag = tabBarController.tabBar.selectedItem?.tag
        let tab: Tabs = Tabs(rawValue: tag!)!
        switch tab {
        case .public_repositories:
            self.performInit(dataSource: self.publicDataSource, for: viewController)
        case .favorite_repositories:
            self.performInit(dataSource: self.favoritesDataSource, for: viewController)
        default:
            return
        }
        
    }
}
