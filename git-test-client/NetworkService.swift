//
//  NetworkService.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper

class NetworkService: NSObject {
    
    func loadRepositories(since: String?, completionHandler: @escaping ([Repository]) -> Void) {
        let parameters: Parameters = ["since": since ?? "0"]
        Alamofire.request("https://api.github.com/repositories", parameters: parameters).responseArray { (response: DataResponse<[Repository]>) in
            guard let repositories = response.result.value else {
                return
            }
            completionHandler(repositories)
        }
    }
    
    func searchRepositories(q: String?, sort: String?, order: String?, completionHandler: @escaping ([Repository]) -> Void) {
        guard q != nil else {
            completionHandler([])
            return
        }

        var parameters: Parameters = ["q": q ?? "dummy"]
        if sort != nil {
            parameters["sort"] = sort
        }
        if order != nil {
            parameters["order"] = order
        }
        Alamofire.request("https://api.github.com/search/repositories", parameters: parameters).responseObject { (response: DataResponse<SearchResult>) in
            guard let results = response.result.value else {
                return
            }
            completionHandler(results.items!)
        }
    }
}
