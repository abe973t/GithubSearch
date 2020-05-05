//
//  ViewController.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
        
    var searchController: UISearchController!
    var users = [User]()
    var cache = NSCache<NSString, UIImage>()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.separatorColor = .black
        
        return tblView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Github Searcher"
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
        
        addViews()
        tableView.register(UserCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func addViews() {
        configureSearchBar()
        view.addSubview(tableView)
        navigationItem.searchController = searchController
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
    
    fileprivate func getUser(url: URL, completion: @escaping (User?)->Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue(Constants.token.rawValue, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            if let data = data {
                do {
                    let responseString = String(decoding: data, as: UTF8.self)
                    if responseString.contains("rate limit") {
                        completion(nil)
                    }
                    let userData = try JSONDecoder().decode(User.self, from: data)
                    completion(userData)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty, let url = URL(string: Constants.searchUsersEndpoint.rawValue + text) {
            var urlRequest = URLRequest(url: url)
            urlRequest.addValue(Constants.token.rawValue, forHTTPHeaderField: "Authorization")
            
            URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
                if err == nil, let data = data {
                    do {
                        let responseString = String(decoding: data, as: UTF8.self)
                        if responseString.contains("rate limit") {
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Error", message: "API rate limit exceeded. (But here\'s the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)", preferredStyle: .alert)
                                let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
                                alert.addAction(okBtn)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
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
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.automaticallyShowsCancelButton = false
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = true
        searchController.searchBar.delegate = self
        searchController.searchBar.showsCancelButton = false
        searchController.searchBar.placeholder = "Search for users"
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserCell else {
            return UITableViewCell()
        }
        
        cell.userNameLabel.text = users[indexPath.row].login
        if let imgURL = users[indexPath.row].avatarUrl {
            if let image = cache.object(forKey: imgURL as NSString) {
                cell.imgView.image = image
            } else {
                cell.imgView.downloadImageFrom(link: imgURL, contentMode: .scaleAspectFit, cache: cache)
            }
        }
        
        if let urlString = users[indexPath.row].url, let url = URL(string: urlString) {
            getUser(url: url) { (userData) in
                if let user = userData, let numOfRepos = user.publicRepos {
                    DispatchQueue.main.async {
                        cell.user = user
                        cell.repoLabel.text = "\(numOfRepos) Repos"
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let userCell = tableView.cellForRow(at: indexPath) as? UserCell {
            DispatchQueue.main.async {
                let pVC = ProfileViewController()
                pVC.user = userCell.user
                pVC.cache = self.cache
                self.navigationController?.pushViewController(pVC, animated: true)
            }
        }
    }
}
