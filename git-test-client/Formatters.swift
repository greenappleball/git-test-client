//
//  Formatters.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/23/16.
//  Copyright © 2016 PI. All rights reserved.
//

import Foundation

enum Formatters {
    enum Date {
        static let medium: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter
        }()
    }
}
