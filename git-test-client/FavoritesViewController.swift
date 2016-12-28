//
//  FavoritesViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/23/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

class FavoritesViewController: UIViewController {

    let repositoriesController: RepositoriesViewController

    //
    init(dataProvider: DataProvider) {
        repositoriesController = RepositoriesViewController(dataProvider: dataProvider)
        super.init(nibName: nil, bundle: nil)
		self.title = "Favorites"
    }

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(viewController: repositoriesController)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repositoriesController.load()
    }
}
