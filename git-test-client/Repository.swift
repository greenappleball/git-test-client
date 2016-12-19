//
//  Repository.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation
import ObjectMapper

class Repository: Mappable {
    var id: Int = 0
    var url: String?
    var name: String?
    var fullName: String?
    var description: String?
    var owner: Owner?
    var htmlUrl: String?
    var forksCount: Int = 0
    var stargazersCount: Int = 0
    var language: String?
    var updatedAt: String?
    var updatedOn: String?
    
    static let dateFormatter = DateFormatter()
    
    
    // Mappable
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        url <- map["url"]
        name <- map["name"]
        htmlUrl <- map["html_url"]
        fullName <- map["full_name"]
        description <- map["description"]
        forksCount <- map["forks_count"]
        stargazersCount <- map["stargazers_count"]
        owner <- map["owner"]
        language <- map["language"]
        updatedAt <- map["updated_at"]
        
        if let updatedAtStr = updatedAt {
            Repository.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            if let updated = Repository.dateFormatter.date(from: updatedAtStr) {
                Repository.dateFormatter.dateFormat = "MMM dd, yyyy"
                updatedOn = "Updated on \(Repository.dateFormatter.string(from: updated))"
            }
        }
    }
}
