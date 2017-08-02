//
//  RepositoriesViewController.swift
//  git-test-client
//
//  Created by Dmitri Petrishin on 12/27/16.
//  Copyright © 2016 PI. All rights reserved.
//

import UIKit
import MBProgressHUD

import RxCocoa
import RxSwift

class RepositoriesViewController: UITableViewController {

    var repositories = Variable<[Repository]>([])
    let dataProvider: DataProvider

    let bag = DisposeBag()

    var refreshMoreAction: (() -> Void)?

    // MARK: - init

    init(dataProvider: DataProvider) {
        self.dataProvider = dataProvider
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: -

	func setupTableView() {

        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.estimatedRowHeight = 84
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "RepositoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CellIdentifier")

        let tv = self.tableView!
        repositories.asObservable()
            .bind(to: tv.rx.items(cellIdentifier: "CellIdentifier")) { [unowned self] (index, item: Repository, cell: RepositoryTableViewCell) in
                cell.updateWithRepository(item)
                self.loadDetails(of: item, completionHandler: { [unowned cell] repository in
                    cell.updateWithRepository(repository)
                })
            }
            .addDisposableTo(bag)

        tv.rx.modelSelected(Repository.self)
            .subscribe(onNext: { [unowned self] item in
                self.loadDetails(of: item, completionHandler: { [unowned self] repository in
                    self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .done, target: nil, action: nil)
                    guard let vc = ReadMeViewController(repository: repository) else {
                        return
                    }
                    self.navigationController?.pushViewController(vc, animated: true)
                })
            })
            .addDisposableTo(bag)
        
        tv.rx.didEndDisplayingCell
            .subscribe(onNext: { [unowned self] (cell: UITableViewCell, indexPath: IndexPath) in
                let lastElement = self.repositories.value.count - 1
                if indexPath.row == lastElement {
                    self.refreshMoreAction?()
                }
            })
            .addDisposableTo(bag)
    }

	override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    // MARK: -

    func clear() {
        repositories.value = []
        tableView.reloadData()
    }

    func cancelLoading() {
        dataProvider.cancel()
    }

    func load() {
        let hud = MBProgressHUD.showTextHUDInView(view)

        dataProvider.load { [weak self] repositories in
            self?.repositories.value = repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        }
    }

    func loadMore()  {
        let hud = MBProgressHUD.showTextHUDInView(navigationController?.view ?? view)
        dataProvider.loadMore { [weak self] repositories in
            self?.repositories.value += repositories
            self?.tableView.reloadData()
            hud.hide(animated: true)
        }
    }

    func loadDetails(of repository: Repository, completionHandler callback: @escaping (Repository) -> Void) {
        if repository.isDetailed {
            callback(repository)
        } else {
            dataProvider.loadRepositoryDetails(repository, completionHandler: { detailedRepository in
                repository.stargazersCount = detailedRepository.stargazersCount
                repository.forksCount = detailedRepository.forksCount
                repository.updatedAt = detailedRepository.updatedAt
                callback(repository)
            })
        }
    }

    func searchTerm(_ term: String) {
        let hud = MBProgressHUD.showTextHUDInView(view, with: "Searching...")
        dataProvider.searchTerm(term, sort: nil, order: nil, completionHandler: { [weak self] repositories in
            self?.repositories.value = repositories
            hud.hide(animated: true)
        })
    }
}
