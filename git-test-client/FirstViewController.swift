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

    let dataSource = DataSource()
    let dataProvider = NetworkDataProvider()
    var timer: Timer?
    @IBOutlet weak var searchBar: UISearchBar!


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = dataSource
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
            vc?.repository = dataSource.item(for: indexPath)
        }
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
                    self?.dataSource.repositories = repositories
                    self?.tableView.reloadData()
                    hud.hide(animated: true)
                })
            })
        } else {
            dataSource.clear {
                self.tableView.reloadData()
            }
        }
    }

}

