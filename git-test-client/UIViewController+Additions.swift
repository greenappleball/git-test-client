//
//  UIViewController+Additions.swift
//  git-test-client
//
//  Created by Alex Antonyuk on 12/27/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

extension UIViewController {

	func embedIntoNavigationController(_ callback: ((UINavigationController) -> Void)?) -> UINavigationController {
		let navVC = UINavigationController(rootViewController: self)
		callback?(navVC)
		return navVC
	}

	func makeTabInNavigationController(with image: UIImage? = nil) -> UINavigationController {
		return embedIntoNavigationController { nc in
			nc.tabBarItem = UITabBarItem(title: self.title, image: image, selectedImage: nil)
		}
	}

    func addChild(viewController controller: UIViewController) {
        addChildViewController(controller)
        controller.view.frame = view.bounds
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
    }
}
