//
//  ReadMeViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/16/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import WebKit
import Down
import ObjectMapper

class ReadMeViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var addItem: UIBarButtonItem?
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

        let network = NetworkService()
        guard let repos = self.repository else {
            return
        }
        if let fullName = repos.fullName {
            self.title = fullName + "/README"
        } else {
            self.title = "README"
        }

        network.loadReadme(for: repos) { readme in
            if let content = readme.content {
                guard let htmlBase65 = content.fromBase64() else {
                    return
                }
                let md = Down(markdownString: htmlBase65)
                if let html = try? md.toHTML() {
                    self.webView.loadHTMLString(html, baseURL: nil)
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWeb"{
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? WebViewController
            vc?.repository = self.repository
        }
    }

    @IBAction func addFavoriteHandler(_ sender: Any) {
        guard let repository = self.repository else {
            return
        }
        DataProvider.add(repository: repository)
    }

}
