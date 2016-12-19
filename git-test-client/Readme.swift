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
    var gitUrl: String?
    var htmlUrl: String?
    var downloadUrl: String?
    var type: String?
    var content: String?
    // Mappable
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        url <- map["url"]
        name <- map["name"]
        htmlUrl <- map["html_url"]
        sha <- map["sha"]
        size <- map["size"]
        size <- map["size"]
        gitUrl <- map["git_url"]
        downloadUrl <- map["download_url"]
        type <- map["type"]
        content <- map["content"]
    }
    
}
