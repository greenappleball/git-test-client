//
//  RootViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class RootViewController: UITableViewController {
    var dataSource = DataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "CellIdentifier")
        self.tableView.delegate = self
        self.tableView.dataSource = self.dataSource
        self.dataSource.load(since: nil, completionHandler: {
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailes"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? DetailViewController
            vc?.repository = self.dataSource.item(by: self.tableView.indexPathForSelectedRow as NSIndexPath?)
        }
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetailes", sender: self)
    }
    
}

