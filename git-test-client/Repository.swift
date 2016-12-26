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
    var updatedAt: Date? {
        willSet {
            if let value = newValue {
                updatedOn = "Updated on \(Formatters.Date.medium.string(from: value))"
            }
        }
    }
    var updatedOn: String?
    
    var isDetailed = false
    
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
        updatedAt <- (map["updated_at"], ISO8601DateTransform())
    }

    func loadDetails(completionHandler: @escaping (_ repository: Repository) -> Void) {
        guard !isDetailed else {
            return
        }

        NetworkService.sharedInstance.loadDetails(for: self) { [weak self] repository in
            self?.stargazersCount = repository.stargazersCount
            self?.forksCount = repository.forksCount
            self?.language = repository.language
            self?.isDetailed = true
            completionHandler(self!)
        }
    }

    // favorites manager
    func isRepositories(_ repositories: [Repository], contains repository: Repository) -> Bool {
        return repositories.contains(where: { (object: Repository) -> Bool in return object.id == repository.id })
    }

    func isFavorite() -> Bool {
        guard let urlCache = Storage.Path.favorites else {
            return false
        }
        let cache = FavoritesDataProvider.cachedRepositories(by: urlCache)
        return isRepositories(cache, contains: self)
    }

    func addToFavorite() {
        do {
            guard let urlCache = Storage.Path.favorites else {
                throw Errors.Internal.wrongCachePath
            }
            var cache = FavoritesDataProvider.cachedRepositories(by: urlCache)
            if !isRepositories(cache, contains: self) {
                cache.append(self)
                try cache.toJSONString()?.write(to: urlCache, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    func removeFromFavorite() {
        do {
            guard let urlCache = Storage.Path.favorites else {
                throw Errors.Internal.wrongCachePath
            }
            var cache = FavoritesDataProvider.cachedRepositories(by: urlCache)
            if let index = cache.index(where: { (object: Repository) -> Bool in object.id == self.id }) {
                cache.remove(at: index)
                try cache.toJSONString()?.write(to: urlCache, atomically: true, encoding: .utf8)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }


}
