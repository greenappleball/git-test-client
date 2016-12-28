//
//  FirstViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {

    var timer: Timer?
    var searchBar: UISearchBar!
    let repositoriesController: RepositoriesViewController


    init(dataProvider: DataProvider) {
        repositoriesController = RepositoriesViewController(dataProvider: dataProvider)
        super.init(nibName: nil, bundle: nil)
		self.title = "Search"
    }

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: repositoriesController.tableView.frame.width, height: 44))
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        repositoriesController.tableView.tableHeaderView = searchBar
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(viewController: repositoriesController)

        setupSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }

    // UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        repositoriesController.cancelLoading()
        if searchText.characters.count > 0 {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { [weak self] _ in
                self?.repositoriesController.searchTerm(searchText)
            })
        } else {
            repositoriesController.clear()
        }
    }

}

