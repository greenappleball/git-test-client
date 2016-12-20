//
//  NetworkDataProvider.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

class NetworkDataProvider: DataProvider {

    let network = NetworkService()

    override func load(completionHandler: @escaping () -> Void) {
        network.loadRepositories() {responce in
            self.repositories = responce
            completionHandler()
        }
    }
    
    override func loadMore(completionHandler: @escaping () -> Void) {
        network.loadRepositories() {responce in
            self.repositories += responce
            completionHandler()
        }
    }

    override func found(by text: String?, sort: String?, order: String?, completionHandler: @escaping () -> Void) {
        network.searchRepositories(q: text, sort: sort, order: order) { responce in
            self.repositories = responce
            completionHandler()
        }
    }

    func cancel() {
        network.cancel()
    }
}
