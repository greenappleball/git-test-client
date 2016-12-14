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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? WebViewController
            vc?.repository = self.repository
        }
    }
}
