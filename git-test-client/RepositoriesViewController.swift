//
//  RepositoriesViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/27/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

class RepositoriesViewController: UITableViewController {

    var repositories: [Repository] = []
    let dataProvider: DataProvider

    var refreshMoreAction: (() -> Void)?

    // MARK: - init

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

	func setupTableView() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
	}

	override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let item = repositories[indexPath.row]

        if let repositoryTableViewCell = cell as? RepositoryTableViewCell {
            repositoryTableViewCell.updateWithRepository(item)
            loadDetails(of: item, completionHandler: { [weak repositoryTableViewCell] repository in
                repositoryTableViewCell?.updateWithRepository(repository)
            })
        } else {
            cell.textLabel?.text = item.fullName
        }
        return cell
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = repositories[indexPath.row]
        loadDetails(of: item, completionHandler: { [weak self] repository in
            self?.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            guard let vc = ReadMeViewController(repository: repository) else {
                return
            }
            self?.navigationController?.pushViewController(vc, animated: true)
        })
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = repositories.count - 1
        if indexPath.row == lastElement {
            refreshMoreAction?()
        }
    }

    // MARK: -

    func clear() {
        repositories = []
        tableView.reloadData()
    }

    func cancelLoading() {
        dataProvider.cancel()
    }

    func load() {
        let hud = MBProgressHUD.showTextHUDInView(view)

        dataProvider.load { [weak self] repositories in
            self?.repositories = repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        }
    }

    func loadMore()  {
        let hud = MBProgressHUD.showTextHUDInView(navigationController?.view ?? view)
        dataProvider.loadMore { [weak self] repositories in
            self?.repositories += repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        }
    }

    func loadDetails(of repository: Repository, completionHandler callback: @escaping (Repository) -> Void) {
        if repository.isDetailed {
            callback(repository)
        } else {
            dataProvider.loadRepositoryDetails(repository, completionHandler: { detailedRepository in
                repository.stargazersCount = detailedRepository.stargazersCount
                repository.forksCount = detailedRepository.forksCount
                repository.updatedAt = detailedRepository.updatedAt
                callback(repository)
            })
        }
    }

    func searchTerm(_ term: String) {
        let hud = MBProgressHUD.showTextHUDInView(view, with: "Searching...")
        dataProvider.searchTerm(term, sort: nil, order: nil, completionHandler: { [weak self] repositories in
            self?.repositories = repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        })
    }
}
