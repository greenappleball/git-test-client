//
//  FavoritesViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/23/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

class FavoritesViewController: UITableViewController {

    var repositories: [Repository] = []
    var dataProvider: DataProvider

    //
    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init(style: .plain)
		self.title = "Favorites"
    }

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func load() {
        let hud = MBProgressHUD.showTextHUDInView(self.view)

        dataProvider.load { [weak self] repositories in
            self?.repositories = repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }

    // UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let item = repositories[indexPath.row]

        if let repositoryTableViewCell = cell as? RepositoryTableViewCell {
            repositoryTableViewCell.updateWithRepository(item)
            dataProvider.loadRepositoryDetails(item, completionHandler: { [weak repositoryTableViewCell] repository in
                repositoryTableViewCell?.updateWithRepository(repository)
            })
        } else {
            cell.textLabel?.text = item.fullName
        }
        return cell
    }

    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        guard let vc = ReadMeViewController(repository: repositories[indexPath.row]) else {
            return
        }
        navigationController?.pushViewController(vc, animated: true)
    }


}
