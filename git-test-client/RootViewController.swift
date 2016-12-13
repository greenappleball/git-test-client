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
        self.tableView.dataSource = self.dataSource
        self.dataSource.load(since: nil, completionHandler: {
            self.tableView.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

