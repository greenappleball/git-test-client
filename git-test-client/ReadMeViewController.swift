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

class ReadMeViewController: UIViewController, WKNavigationDelegate {

    var repository: Repository?
    var webView: WKWebView!

    var addFavorite: ((Repository) -> Void)?
    
    override func loadView() {
        self.webView = WKWebView()
        self.webView.navigationDelegate = self
        self.webView.allowsBackForwardNavigationGestures = true
        self.view = self.webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
        self.addFavorite!(self.repository!)
    }

}
