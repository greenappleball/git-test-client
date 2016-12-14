//
//  DetailViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var repository: Repository?

    override func viewDidLoad() {
        self.title = repository?.full_name
    }
}
