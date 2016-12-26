//
//  DataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/23/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

protocol DataProvider {

    // cancels current loads when searching
    func cancel()
    // loads repositories array
    func load(completionHandler: @escaping (_ repositories: [Repository]) -> Void)
    // continues to load repositories array
    func loadMore(completionHandler: @escaping (_ repositories: [Repository]) -> Void)
    // loads details of repository
    func loadRepositoryDetails(_ repository: Repository, completionHandler: @escaping (_ repository: Repository) -> Void)
    // loads repositories array by seaching term
    func searchTerm(_ term: String?, sort: String?, order: String?, completionHandler: @escaping (_ repositories: [Repository]) -> Void)

}
