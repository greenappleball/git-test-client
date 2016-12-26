//
//  DataSource.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {

    var repositories: [Repository] = []

    // Returns count of repositories
    func count() -> Int {
        return repositories.count;
    }
    
    // Returns `Repository` for `indexPath`
    func item(for indexPath: IndexPath) -> Repository {
        return repositories[indexPath.row]
    }
    
    // Clear `repositories` array
    func clear(completionHandler: @escaping () -> Void) {
        repositories = []
        completionHandler()
    }

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let item = self.item(for: indexPath)

        if let repositoryTableViewCell = cell as? RepositoryTableViewCell {
            repositoryTableViewCell.updateWithRepository(item)
            item.loadDetails(completionHandler: { [weak repositoryTableViewCell] repository in
                repositoryTableViewCell?.updateWithRepository(repository)
            })
        } else {
            cell.textLabel?.text = item.fullName
        }
        return cell
    }


}
