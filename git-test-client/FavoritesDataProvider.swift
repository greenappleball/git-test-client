//
//  FavoritesDataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation


class FavoritesDataProvider: DataProvider, FavoritesManager {

    static func cachedRepositories(by pathUrl: URL) -> [Repository] {
        do {
            let text = try String(contentsOf: pathUrl, encoding: .utf8)
            guard let repositories = [Repository](JSONString: text, context: nil) else {
                return []
            }
            return repositories
        } catch let error as NSError {
            print(error.localizedDescription)
            return []
        }
    }

    // DataProvider
    internal func cancel() {
    }

    internal func load(completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        if let pathUrl = Storage.Path.favorites {
            let repositories = FavoritesDataProvider.cachedRepositories(by: pathUrl)
            completionHandler(repositories)
        } else {
            completionHandler([])
        }
    }

    internal func loadRepositoryDetails(_ repository: Repository, completionHandler: @escaping (_ repository: Repository) -> Void) {
        NetworkService.sharedInstance.loadDetails(for: repository) { repository in completionHandler(repository) }
    }

    // Do nothing for local storage
    internal func loadMore(completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        completionHandler([])
    }

    // Do nothing for local storage
    internal func searchTerm(_ term: String?, sort: String?, order: String?, completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        completionHandler([])
    }

    // FavoritesManager
    static func isRepositories(_ repositories: [Repository], contains repository: Repository) -> Bool {
        return repositories.contains(where: { (object: Repository) -> Bool in return object.id == repository.id })
    }

    internal static func isFavoriteRepository(_ repository: Repository) -> Bool {
        guard let urlCache = Storage.Path.favorites else {
            return false
        }
        let cache = FavoritesDataProvider.cachedRepositories(by: urlCache)
        return isRepositories(cache, contains: repository)
    }

    internal static func addToFavoriteRepository(_ repository: Repository) {
        do {
            guard let urlCache = Storage.Path.favorites else {
                throw Errors.Internal.wrongCachePath
            }
            var cache = FavoritesDataProvider.cachedRepositories(by: urlCache)
            if !isRepositories(cache, contains: repository) {
                cache.append(repository)
                try cache.toJSONString()?.write(to: urlCache, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    internal static func removeFromFavoriteRepository(_ repository: Repository) {
        do {
            guard let urlCache = Storage.Path.favorites else {
                throw Errors.Internal.wrongCachePath
            }
            var cache = FavoritesDataProvider.cachedRepositories(by: urlCache)
            if let index = cache.index(where: { (object: Repository) -> Bool in object.id == repository.id }) {
                cache.remove(at: index)
                try cache.toJSONString()?.write(to: urlCache, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

}
