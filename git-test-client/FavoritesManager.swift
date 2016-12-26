//
//  FavoritesManager.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/26/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

protocol FavoritesManager {

    // is favorite repository
    static func isFavoriteRepository(_ repository: Repository) -> Bool

    // add repository to favorites
    static func addToFavoriteRepository(_ repository: Repository) -> Void
    
    // remove repository from favorites
    static func removeFromFavoriteRepository(_ repository: Repository) -> Void

}
