//
//  NetworkService.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Alamofire

class NetworkService: NSObject {

    func loadRepos(since: String?, completionHandler: @escaping (NSArray) -> Void) {
        let parameters: Parameters = ["since": since ?? "0"]
        Alamofire.request("https://api.github.com/repositories", parameters: parameters).responseJSON { response in
            if let jsonValue = response.result.value {
                guard let json = jsonValue as? NSArray else {
                    return
                }
                completionHandler(json)
            }
        }
    }
}
