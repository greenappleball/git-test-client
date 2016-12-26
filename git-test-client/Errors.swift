//
//  Errors.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/26/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

enum Errors {
    enum Internal {
        static let wrongCachePath: NSError = {
            return NSError(domain: "github-test-client-internal-error", code: 500, userInfo: [NSLocalizedDescriptionKey : "Internal error: no cache path found"])
        }()
    }
}
