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
    var id: Int = 0
    var url: String?
    var name: String?
    var full_name: String?
    var description: String?
    var owner: Owner?
    var html_url: String?
    var forks_count: Int = 0
    var stargazers_count: Int = 0
    var language: String?
    var updated_at: String?
    var updated_on: String?

    static let dateFormatter = DateFormatter()


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
        forks_count <- map["forks_count"]
        stargazers_count <- map["stargazers_count"]
        owner <- map["owner"]
        language <- map["language"]
        updated_at <- map["updated_at"]

        if let updated_at_str = updated_at {
            Repository.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let updated = Repository.dateFormatter.date(from: updated_at_str) {
                Repository.dateFormatter.dateFormat = "MMM dd, yyyy"
                updated_on = "Updated on \(Repository.dateFormatter.string(from: updated))"
            }
        }
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

class SearchResult: Mappable {
    var items: [Repository]?
    var total_count: Int?
    
    // Mappable
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        total_count <- map["total_count"]
    }
}
