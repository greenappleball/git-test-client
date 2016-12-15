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
    
    let token = "ccef102942e86395e41f8c2900c47118fde5ce7a"
    var url_next = "https://api.github.com/repositories"

    func loadRepositories(completionHandler: @escaping ([Repository]) -> Void) {
        if self.url_next.characters.count <= 0 {
            completionHandler([])
        }

        let parameters: Parameters = ["access_token": token]
        Alamofire.request(self.url_next, parameters: parameters).responseArray { (response: DataResponse<[Repository]>) in
            let headers = response.response?.allHeaderFields
            if var links = headers?["Link"] as? String {
                let regex = try! NSRegularExpression(pattern: "<([^\\s]+)>; rel=\"([^\\s]+)\"", options: [])
                let replacedStr = regex.stringByReplacingMatches(in: links, options: [], range: NSRange(location: 0, length: links.characters.count), withTemplate: "\"$2\": \"$1\"")
                let dict = ("{" + replacedStr + "}").toDictionary()
                self.url_next = dict?["next"] as! String
            }

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

        var parameters: Parameters = ["access_token": token, "q": q!]
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

    func loadReadme(for repository: Repository, completionHandler: @escaping (Readme) -> Void) {
        guard let url = repository.url else {
            return
        }

        let parameters: Parameters = ["access_token": token]
        Alamofire.request(url + "/readme", parameters: parameters).responseObject { (response: DataResponse<Readme>) in
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
        
        let parameters: Parameters = ["access_token": token]
        Alamofire.request(url, parameters: parameters).responseObject { (response: DataResponse<Repository>) in
            guard let result = response.result.value else {
                return
            }
            completionHandler(result)
        }
    }
}
