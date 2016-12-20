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

    static func pathUrlWithFilename(_ filename: String) throws -> URL {
        return try documentsPath(withComponet: filename)
    }

    static func cachedRepositories(by pathUrl: URL) -> Array<Repository> {
        do {
            let text = try String(contentsOf: pathUrl, encoding: .utf8)
            guard let repositories = Array<Repository>(JSONString: text, context: nil) else {
                return []
            }
            return repositories
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }

    static func isRepositories(_ repositories: Array<Repository>, contains repository: Repository) -> Bool {
        return repositories.contains(where: { (object: Repository) -> Bool in return object.id == repository.id })
    }

    static func isFavoriteRepository(_ repository: Repository) -> Bool {
        guard let path = try? pathUrlWithFilename("favorites.txt") else {
            return false
        }
        let cache = cachedRepositories(by: path)
        return isRepositories(cache, contains: repository)
    }

    // Adds new `repository` to local storage in `favorites.txt`
    static func addToFavoriteRepository(_ repository: Repository) {
        do {
            let pathUrl = try pathUrlWithFilename("favorites.txt")
            var cache = cachedRepositories(by: pathUrl)
            if !isRepositories(cache, contains: repository) {
                cache.append(repository)
                try cache.toJSONString()?.write(to: pathUrl, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // Removes `repository` from local storage in `favorites.txt`
    static func removeFromFavoriteRepository(_ repository: Repository) {
        do {
            let pathUrl = try pathUrlWithFilename("favorites.txt")
            var cache = cachedRepositories(by: pathUrl)
            if let index = cache.index(where: { (object: Repository) -> Bool in object.id == repository.id }) {
                cache.remove(at: index)
                try cache.toJSONString()?.write(to: pathUrl, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func load(completionHandler: @escaping () -> Void) {
        do {
            let pathUrl = try DataProvider.pathUrlWithFilename("favorites.txt")
            self.repositories = DataProvider.cachedRepositories(by: pathUrl)
            completionHandler()
        } catch let error as NSError {
            print(error.localizedDescription)
            completionHandler()
        }
    }

    // Do nothing for local storage
    func loadMore(completionHandler: @escaping () -> Void) {
        completionHandler()
    }

    // Do nothing for local storage
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
