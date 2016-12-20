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
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let network = NetworkService()
        guard let repos = repository else {
            return
        }
        if let fullName = repos.fullName {
            title = fullName + "/README"
        } else {
            title = "README"
        }

        addItem?.title = DataProvider.isFavoriteRepository(repos) ? "-" : "+"

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
            navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
            let vc = segue.destination as? WebViewController
            vc?.repository = repository
        }
    }

    @IBAction func addFavoriteHandler(_ sender: UIBarButtonItem) {
        guard let repository = repository else {
            return
        }
        if DataProvider.isFavoriteRepository(repository) {
            DataProvider.removeFromFavoriteRepository(repository)
            sender.title = "+"
        } else {
            DataProvider.addToFavoriteRepository(repository)
            sender.title = "-"
        }
    }

}
