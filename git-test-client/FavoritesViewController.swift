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

    let dataSource = DataSource()
    let dataProvider = FavoritesDataProvider()
    
    
    //
    func load() {
        let hud = MBProgressHUD.showTextHUDInView(self.view)

        dataProvider.load { [weak self] repositories in
            self?.dataSource.repositories = repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = dataSource
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
            vc?.repository = dataSource.item(for: indexPath)
        }
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }


}
