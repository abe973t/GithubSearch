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
    var users = [User]()
    
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
    
    fileprivate func getUser(url: URL, completion: @escaping (User)->Void) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
                do {
                    let userData = try JSONDecoder().decode(User.self, from: data)
                    completion(userData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

extension ViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let text = searchController.searchBar.text, !text.isEmpty, let url = URL(string: Constants.searchUsersEndpoint.rawValue + text) {
                URLSession.shared.dataTask(with: url) { (data, response, err) in
                    if err == nil, let data = data {
                        do {
                            let results = try JSONDecoder().decode(GithubResults.self, from: data)
                            self.users = results.items ?? []
                           
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }.resume()
            }
        }
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
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserCell else {
            return UITableViewCell()
        }
        
        cell.userNameLabel.text = users[indexPath.row].login
        cell.imgView.downloadImageFrom(link: users[indexPath.row].avatar_url!, contentMode: .scaleAspectFit)
//        cell.repoLabel.text = "Repos: \(String(describing: users[indexPath.row].repos))"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let urlString = users[indexPath.row].url, let url = URL(string: urlString) {
            getUser(url: url) { (user) in
                DispatchQueue.main.async {
                    let pVC = ProfileViewController()
                    pVC.user = user
                    self.navigationController?.pushViewController(pVC, animated: true)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
