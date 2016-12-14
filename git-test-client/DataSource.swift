//
//  DataSource.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {
    let network = NetworkService()
    var repositories: [Repository] = []

    func clear(completionHandler: @escaping () -> Void) {
        self.repositories = []
        completionHandler()
    }

    func load(since: String?, completionHandler: @escaping () -> Void) {
        network.loadRepositories(since: since) {responce in
            self.repositories = responce
            completionHandler()
        }
    }

    func loadMore(completionHandler: @escaping () -> Void) {
        network.loadRepositories(since: nil) {responce in
            self.repositories = responce
            completionHandler()
        }
    }

    func search(by text: String?, sort: String?, order: String?, completionHandler: @escaping () -> Void) {
        network.searchRepositories(q: text, sort: sort, order: order) { responce in
            self.repositories = responce
            completionHandler()
        }
    }

    func count() -> Int {
        return repositories.count;
    }

    func item(by indexPath: NSIndexPath?) -> Repository {
        return self.repositories[(indexPath?.row)!]
    }

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.count();
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        cell.textLabel?.text = self.repositories[indexPath.row].full_name
        return cell;
    }
}
