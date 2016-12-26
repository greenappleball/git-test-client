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
    let dataProvider = FavoritesDataProvider()
    
    
    //
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        load()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
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
        performSegue(withIdentifier: "showDetails", sender: self)
    }


}
