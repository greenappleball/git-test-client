//
//  DataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

enum Type: Int {
    case search = 0
    case common
    case favorites
}

import Foundation

class DataProvider: NSObject {

    var type: Type
    let network = NetworkService()
    var repositories: [Repository] = []

    var isFavorite: Bool {
        get {
            return self.type == Type.favorites
        }
    }

    // initializer
    init(type: Type) {
        self.type = type
        super.init()
    }

    // Returns documents path with appending path component `name`
    static func documentsPath(withComponet name: String) throws -> URL {
        let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent(name)
    }

    // Adds new `repository` to local storage in `favorites.txt`
    static func add(repository: Repository) {
        do {
            var repos: Array<Repository> = []
            let path = try DataProvider.documentsPath(withComponet: "favorites.txt")
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

    // Removes `repository` from local storage in `favorites.txt`
    static func remove(repository: Repository) {
    }
    
    // Returns count of repositories
    func count() -> Int {
        return self.repositories.count;
    }

    // Returns `Repository` for `indexPath`
    func item(for indexPath: IndexPath?) -> Repository {
        return self.repositories[(indexPath?.row)!]
    }

    // Clear `repositories` array
    func clear(completionHandler: @escaping () -> Void) {
        self.repositories = []
        completionHandler()
    }

    func loadFavorites(completionHandler: @escaping ([Repository]) -> Void) {
        do {
            var repos: Array<Repository> = []
            let path = try DataProvider.documentsPath(withComponet: "favorites.txt")
            if let text = try? String(contentsOf: path, encoding: .utf8) {
                repos = Array<Repository>(JSONString: text, context: nil)!
            }
            completionHandler(repos)
        } catch let error as NSError {
            print(error.localizedDescription)
            completionHandler([])
        }
    }

    func load(completionHandler: @escaping () -> Void) {
        if self.isFavorite {
            self.loadFavorites(completionHandler: { repositories in
                self.repositories = repositories
                completionHandler()
            })
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

    func found(by text: String?, sort: String?, order: String?, completionHandler: @escaping () -> Void) {
        network.searchRepositories(q: text, sort: sort, order: order) { responce in
            self.repositories = responce
            completionHandler()
        }
    }
}
