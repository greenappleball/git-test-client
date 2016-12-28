//
//  RootViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

class PublicReposViewController: UIViewController {

    let repositoriesController: RepositoriesViewController

    //
    init(dataProvider: DataProvider) {
        repositoriesController = RepositoriesViewController.init(dataProvider: dataProvider)
        super.init(nibName: nil, bundle: nil)
		self.title = "Repositories"
    }

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(viewController: repositoriesController)

        repositoriesController.refreshMoreAction = { [weak self] in
            self?.repositoriesController.loadMore()
        }
        repositoriesController.load()
    }
}

