//
//  NetworkService.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Alamofire
import ObjectMapper
import AlamofireObjectMapper

class NetworkService: NSObject {
    
    var url_next = "https://api.github.com/repositories"

    func loadRepositories(completionHandler: @escaping ([Repository]) -> Void) {
        if self.url_next.characters.count <= 0 {
            completionHandler([])
        }

        Alamofire.request(self.url_next).responseArray { (response: DataResponse<[Repository]>) in
            let headers = response.response?.allHeaderFields
            if var links = headers?["Link"] as? String {
                let regex = try! NSRegularExpression(pattern: "<([^\\s]+)>; rel=\"([^\\s]+)\"", options: [])
                let replacedStr = regex.stringByReplacingMatches(in: links, options: [], range: NSRange(location: 0, length: links.characters.count), withTemplate: "\"$2\": \"$1\"")
                let dict = ("{" + replacedStr + "}").toDictionary()
                self.url_next = dict?["next"] as! String
            }

            if let repositories = response.result.value {
                completionHandler(repositories)
            } else {
                completionHandler([])
            }
        }
    }
    
    func searchRepositories(q: String?, sort: String?, order: String?, completionHandler: @escaping ([Repository]) -> Void) {
        guard q != nil else {
            completionHandler([])
            return
        }

        var parameters: Parameters = ["q": q!]
        if sort != nil {
            parameters["sort"] = sort
        }
        if order != nil {
            parameters["order"] = order
        }
        Alamofire.request("https://api.github.com/search/repositories", parameters: parameters).responseObject { (response: DataResponse<SearchResult>) in
            if let results = response.result.value {
                if let items = results.items {
                    completionHandler(items)
                } else {
                    completionHandler([])
                }
            } else {
                completionHandler([])
            }
        }
    }

    func loadReadme(for repository: Repository, completionHandler: @escaping (Readme) -> Void) {
        guard let url = repository.url else {
            return
        }

        Alamofire.request(url + "/readme").responseObject { (response: DataResponse<Readme>) in
            guard let result = response.result.value else {
                return
            }
            completionHandler(result)
        }
    }

    func loadDetails(for repository: Repository, completionHandler: @escaping (Repository) -> Void) {
        guard let url = repository.url else {
            return
        }
        
        Alamofire.request(url).responseObject { (response: DataResponse<Repository>) in
            guard let result = response.result.value else {
                return
            }
            completionHandler(result)
        }
    }
}
