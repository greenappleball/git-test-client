//
//  Readme.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation
import ObjectMapper

class Readme: Mappable {
    var sha: String?
    var path: String?
    var name: String?
    var size: Int?
    var url: String?
    var git_url: String?
    var html_url: String?
    var download_url: String?
    var type: String?
    var content: String?
    // Mappable
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        name <- map["name"]
        html_url <- map["html_url"]
        sha <- map["sha"]
        size <- map["size"]
        size <- map["size"]
        git_url <- map["git_url"]
        download_url <- map["download_url"]
        type <- map["type"]
        content <- map["content"]
    }
    
}
