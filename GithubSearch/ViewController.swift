//
//  ViewController.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var searchController: UISearchController!
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.backgroundColor = .systemRed
        return tblView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Github Searcher"
        addViews()
        navigationItem.searchController = searchController
        navigationController?.navigationBar.backgroundColor = .black
        tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addViews() {
        configureSearchBar()
        view.addSubview(tableView)

        addContraints()
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController!.searchResultsUpdater = self
        searchController!.hidesNavigationBarDuringPresentation = false
        searchController!.automaticallyShowsCancelButton = false
        searchController!.delegate = self
        searchController!.searchBar.sizeToFit()
        searchController!.searchBar.showsCancelButton = true
        searchController!.searchBar.delegate = self
        searchController!.searchBar.showsCancelButton = false
        searchController?.searchBar.placeholder = "Search for users"
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserCell else {
            return UITableViewCell()
        }
        
        cell.imgView.backgroundColor = .systemBlue
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
