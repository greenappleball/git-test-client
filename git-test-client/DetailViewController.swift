//
//  DetailViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/13/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import WebKit
import Down

class DetailViewController: UIViewController, WKNavigationDelegate {

    var repository: Repository?
    var webView: WKWebView!
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.view = self.webView
    }

    override func viewDidLoad() {
        self.title = (repository?.full_name)! + "/README"
        
        let network = NetworkService()
        network.loadReadme(for: self.repository!) { readme in
            if let content = readme.content {
                let md = Down(markdownString: content.fromBase64()!)
                let html = try? md.toHTML()
                self.webView.loadHTMLString(html!, baseURL: nil)
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
