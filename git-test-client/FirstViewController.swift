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
    let dataProvider = NetworkDataProvider()
    var timer: Timer?
    @IBOutlet weak var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Search", style: .done, target: nil, action: nil)
            let vc = segue.destination as? ReadMeViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            vc?.repository = repositories[indexPath.row]
        }
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
        performSegue(withIdentifier: "showDetails", sender: self)
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

