//
//  SearchResult.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation
import ObjectMapper

class SearchResult: Mappable {
    var items: [Repository]?
    var totalCount: Int?
    
    // Mappable
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        totalCount <- map["total_count"]
    }
}
