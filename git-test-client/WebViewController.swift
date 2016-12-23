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

    var repository: Repository!

    var webView: WKWebView!


    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let repository = repository, let htmlUrl = repository.htmlUrl else {
            return
        }

        if let url = URL(string: htmlUrl) {
            webView.load(URLRequest(url: url))
        }
    }


}
