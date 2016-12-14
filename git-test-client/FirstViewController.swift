//
//  FirstViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class FirstViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!

    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellIdentifier")
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailes"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Search", style: .done, target: nil, action: nil)
            let vc = segue.destination as? DetailViewController
            vc?.repository = self.dataSource.item(by: self.tableView.indexPathForSelectedRow as NSIndexPath?)
        }
    }

    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailes", sender: self)
    }

    // UISearchBarDelegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.dataSource.clear {
            self.tableView.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.dataSource.search(by: searchText, sort: nil, order: nil, completionHandler: {
                self.searchBar.resignFirstResponder()
                self.tableView.reloadData()
            })
        } else {
            self.dataSource.clear {
                self.tableView.reloadData()
            }
        }
    }

}

