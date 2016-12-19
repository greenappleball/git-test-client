//
//  WebViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/14/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    var repository: Repository?

    var webView: WKWebView!
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.view = self.webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: (self.repository?.htmlUrl)!)!
        self.webView.load(URLRequest(url: url))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
