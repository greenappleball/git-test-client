//
//  RootViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

class RootViewController: UITableViewController {
    var dataSource: DataSource? {
        get {
            guard let ds = tableView.dataSource else {
                return nil
            }
            return ds as? DataSource
        }
        set {
            tableView.dataSource = newValue
        }
    }
    var dataProvider: DataProvider? {
        guard let _dataProvider = dataSource?.dataProvider else {
            return nil
        }
        return _dataProvider
    }


    //
    func load() {
        guard let provider = dataProvider else {
            return
        }

        let hud = MBProgressHUD.showTextHUDInView(self.view)

        provider.load(completionHandler: {
            self.tableView.reloadData()
            hud.hide(animated: true)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let provider = dataProvider, provider.isFavorite else {
            return
        }

        load()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? ReadMeViewController

            guard let provider = dataProvider else {
                return
            }

            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            vc?.repository = provider.item(for: indexPath)
        }
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let provider = dataProvider, !provider.isFavorite else {
            return
        }

        let lastElement = provider.count() - 1
        if indexPath.row == lastElement {
            let hud = MBProgressHUD.showTextHUDInView(self.view)
            dataProvider?.loadMore {
                tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }


}

