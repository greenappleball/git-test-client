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
    
    var request: DataRequest?
    var urlNext = "https://api.github.com/repositories"


    func loadRepositories(completionHandler: @escaping ([Repository]) -> Void) {
        if urlNext.characters.count <= 0 {
            completionHandler([])
        }

        request = Alamofire.request(urlNext).responseArray { (response: DataResponse<[Repository]>) in
            let headers = response.response?.allHeaderFields
            if var links = headers?["Link"] as? String {
                if let regex = try? NSRegularExpression(pattern: "<([^\\s]+)>; rel=\"([^\\s]+)\"", options: []) {
                    let replacedStr = regex.stringByReplacingMatches(in: links, options: [], range: NSRange(location: 0, length: links.characters.count), withTemplate: "\"$2\": \"$1\"")
                    let dict = ("{" + replacedStr + "}").toDictionary()
                    if let next = dict?["next"] as? String {
                        self.urlNext = next
                    }
                }
            }

            if let repositories = response.result.value {
                completionHandler(repositories)
            } else {
                completionHandler([])
            }
        }
    }
    
    func searchRepositories(q: String?, sort: String?, order: String?, completionHandler: @escaping ([Repository]) -> Void) {
        guard let query = q else {
            completionHandler([])
            return
        }

        var parameters: Parameters = ["q": query]
        if sort != nil {
            parameters["sort"] = sort
        }
        if order != nil {
            parameters["order"] = order
        }
        cancel()
        request = Alamofire.request("https://api.github.com/search/repositories", parameters: parameters).responseObject { (response: DataResponse<SearchResult>) in
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

        request = Alamofire.request(url + "/readme").responseObject { (response: DataResponse<Readme>) in
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
        
        request = Alamofire.request(url).responseObject { (response: DataResponse<Repository>) in
            guard let result = response.result.value else {
                return
            }
            completionHandler(result)
        }
    }

    func cancel() {
        request?.cancel()
    }


}
