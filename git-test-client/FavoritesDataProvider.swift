//
//  FavoritesDataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation


class FavoritesDataProvider: DataProvider {

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

    // Do nothing for local storage
    internal func loadMore(completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        completionHandler([])
    }

    // Do nothing for local storage
    internal func searchTerm(_ term: String?, sort: String?, order: String?, completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        completionHandler([])
    }


}
