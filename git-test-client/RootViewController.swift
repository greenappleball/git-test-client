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
    var dataSource = DataSource()
    
    //
    func hud(with text: String?) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true);
        hud.backgroundView.style = .blur
        hud.label.text = text
        hud.mode = .text
        return hud
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self.dataSource
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84

        let hud = self.hud(with: "Loading...")

        self.dataSource.load(completionHandler: {
            self.tableView.reloadData()
            hud.hide(animated: true)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? DetailViewController
            vc?.repository = self.dataSource.item(by: self.tableView.indexPathForSelectedRow as NSIndexPath?)
        }
    }
    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = self.dataSource.count() - 1
        if indexPath.row == lastElement {
            let hud = self.hud(with: "Loading...")
            self.dataSource.loadMore {
                self.tableView.reloadData()
                hud.hide(animated: true)
            }
        }
    }

}

