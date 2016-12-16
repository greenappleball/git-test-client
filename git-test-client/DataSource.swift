//
//  DataSource.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

enum Type: Int {
    case search = 0
    case repos_public
    case repos_favorites
}

class DataSource: NSObject, UITableViewDataSource {
    var type: Type
    let network = NetworkService()
    var repositories: [Repository] = []

    static func documentsPath(withComponet name: String) throws -> URL {
        let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent(name)
    }

    static func add(repository: Repository) {
        do {
            var repos: Array<Repository> = []
            let path = try DataSource.documentsPath(withComponet: "favorites.txt")
            if let text = try? String(contentsOf: path, encoding: .utf8) {
                repos = Array<Repository>(JSONString: text, context: nil)!
            }
            if !repos.contains(where: { (object: Repository) -> Bool in
                return object.id == repository.id
            }) {
                repos.append(repository)
                try repos.toJSONString()?.write(to: path, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    init(type: Type) {
        self.type = type
        super.init()
    }

    func clear(completionHandler: @escaping () -> Void) {
        self.repositories = []
        completionHandler()
    }

    func load(completionHandler: @escaping () -> Void) {
        if self.type == Type.repos_favorites {
            do {
                var repos: Array<Repository> = []
                let path = try DataSource.documentsPath(withComponet: "favorites.txt")
                if let text = try? String(contentsOf: path, encoding: .utf8) {
                    repos = Array<Repository>(JSONString: text, context: nil)!
                }
                self.repositories = repos
                completionHandler()
            } catch let error as NSError {
                print(error.localizedDescription)
                completionHandler()
            }
        } else {
            network.loadRepositories() {responce in
                self.repositories = responce
                completionHandler()
            }
        }
    }

    func loadMore(completionHandler: @escaping () -> Void) {
        network.loadRepositories() {responce in
            self.repositories += responce
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! RepositoryTableViewCell
        cell.update(with: self.repositories[indexPath.row])
        return cell;
    }
}
