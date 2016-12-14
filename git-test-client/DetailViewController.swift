//
//  DetailViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import WebKit
import SwiftyMarkdown

class DetailViewController: UIViewController, WKNavigationDelegate {

    var repository: Repository?

    @IBOutlet weak var textView: UITextView!

    override func viewDidLoad() {
        self.title = (repository?.full_name)! + "/README"
        self.textView.dataDetectorTypes = UIDataDetectorTypes.all
        
        let network = NetworkService()
        network.loadReadme(for: self.repository!) { readme in
            if let content = readme.content {
                let md = SwiftyMarkdown(string: content.fromBase64()!)
                self.textView.attributedText = md.attributedString()
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? WebViewController
            vc?.repository = self.repository
        }
    }
}
