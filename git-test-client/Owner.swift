//
//  Owner.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/19/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation
import ObjectMapper

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
