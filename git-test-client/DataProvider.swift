//
//  DataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/23/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

protocol DataProvider {

    func cancel()
    func load(completionHandler: @escaping (_ repositories: [Repository]) -> Void)
    func loadMore(completionHandler: @escaping (_ repositories: [Repository]) -> Void)
    func searchTerm(_ term: String?, sort: String?, order: String?, completionHandler: @escaping (_ repositories: [Repository]) -> Void)

}
