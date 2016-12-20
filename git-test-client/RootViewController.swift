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
            guard let ds = self.tableView.dataSource else {
                return nil
            }
            return ds as? DataSource
        }
        set {
            self.tableView.dataSource = newValue
        }
    }
    var dataProvider: DataProvider? {
        get {
            guard let _dataProvider = self.dataSource?.dataProvider else {
                return nil
            }
            return _dataProvider
        }
    }

    //
    func hud(with text: String?) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
        hud.backgroundView.style = .blur
        hud.label.text = text
        hud.mode = .text
        return hud
    }

    func load() {
        guard let provider = self.dataProvider else {
            return
        }

        let hud = self.hud(with: "Loading...")

        provider.load(completionHandler: {
            self.tableView.reloadData()
            hud.hide(animated: true)
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let provider = self.dataProvider, provider.isFavorite else {
            return
        }

        self.load()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? ReadMeViewController

            guard let provider = self.dataProvider else {
                return
            }

            guard let indexPath = self.tableView.indexPathForSelectedRow else {
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
        guard let provider = self.dataProvider, !provider.isFavorite else {
            return
        }

        let lastElement = provider.count() - 1
        if indexPath.row == lastElement {
            let hud = self.hud(with: "Loading...")
            self.dataProvider?.loadMore {
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }

}

