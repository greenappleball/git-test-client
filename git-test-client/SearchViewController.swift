//
//  FirstViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SearchViewController: UIViewController {

    let bag = DisposeBag()
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
        repositoriesController.tableView.tableHeaderView = searchBar

        // Rx
        let clickedCancel = searchBar.rx.cancelButtonClicked.asObservable()
        let clickedSearch = searchBar.rx.searchButtonClicked.asObservable()
        let clickObserver = Observable.from([clickedCancel, clickedSearch])
        clickObserver
            .merge()
            .subscribe(onNext: { [unowned self] _ in
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: bag)
        clickedSearch
            .subscribe(onNext: { [unowned self] _ in
                if let query = self.searchBar.text, query.characters.count > 0 {
                    self.repositoriesController.searchTerm(query)
                }
            })
            .disposed(by: bag)
        //
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .debounce(0.8, scheduler: MainScheduler.instance) // Wait 0.8 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.repositoriesController.searchTerm(query)
            })
            .disposed(by: bag)
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            .orEmpty // Make it non-optional
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .filter { $0.isEmpty } // If the new value is really new, filter for empty query.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.repositoriesController.clear()
            })
            .disposed(by: bag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(viewController: repositoriesController)

        setupSearchBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }

}
