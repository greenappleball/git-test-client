//
//  DataSource.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class DataSource: NSObject, UITableViewDataSource {

    var dataProvider: DataProvider


    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init()
    }

    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataProvider.count()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath)
        let item = dataProvider.item(for: indexPath)

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
