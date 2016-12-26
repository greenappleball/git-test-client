//
//  NetworkDataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

class NetworkDataProvider: DataProvider {

    let network = NetworkService.sharedInstance

    // DataProvider
    internal func cancel() {
        network.cancel()
    }

    internal func load(completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        network.loadRepositories() { responce in completionHandler(responce) }
    }
    
    internal func loadMore(completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        network.loadRepositories() { responce in completionHandler(responce) }
    }

    internal func searchTerm(_ term: String?, sort: String?, order: String?, completionHandler: @escaping (_ repositories: [Repository]) -> Void) {
        network.searchRepositories(q: term, sort: sort, order: order) { responce in completionHandler(responce) }
    }


}
