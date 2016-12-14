//
//  Repository.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: Mappable {
    var id: Int?
    var url: String?
    var name: String?
    var full_name: String?
    var description: String?
    var owner: Owner?
    var html_url: String?
    var forks_url: String?
    var stargazers_url: String?
    var languages_url: String?

    // Mappable
    required init?(map: Map){
        
    }

    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        name <- map["name"]
        html_url <- map["html_url"]
        full_name <- map["full_name"]
        description <- map["description"]
        forks_url <- map["forks_url"]
        stargazers_url <- map["stargazers_url"]
        owner <- map["owner"]
        languages_url <- map["languages_url"]
    }
}

class Owner: Mappable {
    var id: Int?
    var url: String?
    var type: String?
    var login: String?
    var html_url: String?
    var avatar_url: String?

    required init?(map: Map){
    }

    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        type <- map["type"]
        login <- map["login"]
        html_url <- map["html_url"]
        avatar_url <- map["avatar_url"]
    }
}
