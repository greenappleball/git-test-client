//
//  FirstViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

class FirstViewController: UITableViewController, UISearchBarDelegate {

    var repositories: [Repository] = []
    var dataProvider: DataProvider!
    var timer: Timer?
    var searchBar: UISearchBar!


    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init(style: .plain)
    }

    required init?(coder aDecoder: NSCoder) {
        self.dataProvider = NetworkDataProvider()
        super.init(coder: aDecoder)
    }

    func setupSearchBar() {
        searchBar = UISearchBar(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 44))
        searchBar.showsCancelButton = true
        searchBar.delegate = self
    }

    func setupTableView() {
        tableView.tableHeaderView = searchBar

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84

        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
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

    // UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataProvider.cancel()
        if searchText.characters.count > 0 {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { [weak self] _ in
                let hud = MBProgressHUD.showTextHUDInView((self?.view)!, with: "Searching...")
                self?.dataProvider.searchTerm(searchText, sort: nil, order: nil, completionHandler: { [weak self] repositories in
                    self?.repositories = repositories
                    self?.tableView.reloadData()
                    hud.hide(animated: true)
                })
            })
        } else {
            repositories = []
            tableView.reloadData()
        }
    }

}

