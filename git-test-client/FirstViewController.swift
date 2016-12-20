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

    var dataSource = DataSource(dataProvider: NetworkDataProvider())
    var dataProvider: NetworkDataProvider? {
        get {
            return dataSource.dataProvider as? NetworkDataProvider
        }
    }
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 84
    }
    
    override func viewDidAppear(_ animated: Bool) {
        searchBar.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails"{
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "Search", style: .done, target: nil, action: nil)
            let vc = segue.destination as? ReadMeViewController
            guard let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            vc?.repository = dataProvider?.item(for: indexPath)
        }
    }

    //
    func hud(with text: String?) -> MBProgressHUD {
        let hud = MBProgressHUD.showAdded(to: view, animated: true);
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataProvider?.cancel()
        if searchText.characters.count > 0 {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: false, block: { _ in
                let hud = self.hud(with: "Searching...")
                self.dataProvider?.found(by: searchText, sort: nil, order: nil, completionHandler: {
                    self.tableView.reloadData()
                    hud.hide(animated: true)
                })
            })
        } else {
            dataProvider?.clear {
                self.tableView.reloadData()
            }
        }
    }

}

