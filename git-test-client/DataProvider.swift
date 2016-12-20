//
//  FavoritesDataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

class DataProvider: NSObject {
    var repositories: [Repository] = []
    var isFavorite: Bool {
        get {
            return !(self is NetworkDataProvider)
        }
    }

    // Returns documents path with appending path component `name`
    static func documentsPath(withComponet name: String) throws -> URL {
        let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        return documentDirectoryURL.appendingPathComponent(name)
    }

    // Adds new `repository` to local storage in `favorites.txt`
    static func add(repository: Repository) {
        do {
            var repositories: Array<Repository> = []
            let path = try DataProvider.documentsPath(withComponet: "favorites.txt")
            if let text = try? String(contentsOf: path, encoding: .utf8) {
                if let cache = Array<Repository>(JSONString: text, context: nil) {
                    repositories = cache
                }
            }
            if !repositories.contains(where: { (object: Repository) -> Bool in
                return object.id == repository.id
            }) {
                repositories.append(repository)
                try repositories.toJSONString()?.write(to: path, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // Removes `repository` from local storage in `favorites.txt`
    static func remove(repository: Repository) {
    }

    func load(completionHandler: @escaping () -> Void) {
        do {
            var repositories: Array<Repository> = []
            let path = try DataProvider.documentsPath(withComponet: "favorites.txt")
            if let text = try? String(contentsOf: path, encoding: .utf8) {
                if let cache = Array<Repository>(JSONString: text, context: nil) {
                    repositories = cache
                }
                self.repositories = repositories
            }
            completionHandler()
        } catch let error as NSError {
            print(error.localizedDescription)
            completionHandler()
        }
    }

    func loadMore(completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    func found(by text: String?, sort: String?, order: String?, completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    // Returns count of repositories
    func count() -> Int {
        return self.repositories.count;
    }

    // Returns `Repository` for `indexPath`
    func item(for indexPath: IndexPath) -> Repository {
        return self.repositories[indexPath.row]
    }

    // Clear `repositories` array
    func clear(completionHandler: @escaping () -> Void) {
        self.repositories = []
        completionHandler()
    }

}
