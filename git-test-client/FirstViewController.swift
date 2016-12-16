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

    @IBOutlet weak var searchBar: UISearchBar!

    var dataSource = DataSource()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self.dataSource
        self.tableView.delegate = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 84
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Search", style: .done, target: nil, action: nil)
            let vc = segue.destination as? ReadMeViewController
            vc?.repository = self.dataSource.item(by: self.tableView.indexPathForSelectedRow as NSIndexPath?)
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

    // UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetails", sender: self)
    }

    // UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 0 {
            self.timer?.invalidate()
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
                let hud = self.hud(with: "Searching...")
                self.searchBar.resignFirstResponder()
                self.dataSource.search(by: searchText, sort: nil, order: nil, completionHandler: {
                    self.tableView.reloadData()
                    hud.hide(animated: true)
                })
            })
        } else {
            self.dataSource.clear {
                self.tableView.reloadData()
            }
        }
    }

}

