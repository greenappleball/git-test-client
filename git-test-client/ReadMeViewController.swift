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

    var addItem: UIBarButtonItem?
    let repository: Repository
    var webView: WKWebView!


    init?(repository: Repository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func rightBarButtonItems() -> [UIBarButtonItem] {
        let webItem = UIBarButtonItem.init(barButtonSystemItem: .bookmarks, target: self, action: #selector(bookmarkButtonHandler(_:)))
        addItem = UIBarButtonItem.init(title: "-", style: .done, target: self, action: #selector(addFavoriteHandler(_:)))
        return [webItem, addItem!]
    }

    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let fullName = repository.fullName {
            title = fullName + "/README"
        } else {
            title = "README"
        }

        navigationItem.rightBarButtonItems = rightBarButtonItems()
        addItem?.title = FavoritesDataProvider.isFavoriteRepository(repository) ? "-" : "+"

        let network = NetworkService.sharedInstance
        network.loadReadme(for: repository) { readme in
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


    func bookmarkButtonHandler(_ sender: UIBarButtonItem) {
        navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
        let vc = WebViewController(repository: repository)
		navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func addFavoriteHandler(_ sender: UIBarButtonItem) {
        if FavoritesDataProvider.isFavoriteRepository(repository) {
            FavoritesDataProvider.removeFromFavoriteRepository(repository)
            sender.title = "+"
        } else {
            FavoritesDataProvider.addToFavoriteRepository(repository)
            sender.title = "-"
        }
    }


}
