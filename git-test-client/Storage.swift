//
//  Storage.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/23/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation


enum Storage {
    enum Path {
        static let favorites: URL? = {
            guard let documentDirectoryURL = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
                return nil
            }
            return documentDirectoryURL.appendingPathComponent("favorites.txt")
        }()
    }
}
