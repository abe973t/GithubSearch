//
//  ViewController.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    /**
        Potential Questions:
            - For example, why MVC over MVVM?
                The assignment did not require testing.
            - Is there a more efficient way of handling image loading?
                If I had more time I would have implemented NSCaching to cache images.
            - Are there any problems with the way you are loading images now that could cause problems?
                Null image urls are handled gracefully, so I do not see one.
     
        TODO:
            - fix search controller issue
     */
    
    var searchController: UISearchController!
    var users = [User]()
    var cache = NSCache<NSString, UIImage>()
    
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
        navigationController?.navigationBar.backgroundColor = .white
        view.backgroundColor = .white
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
    
    fileprivate func getUser(url: URL, completion: @escaping (User?)->Void) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
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
    
    fileprivate func getRepos(url: URL, completion: @escaping (Int)->Void) {
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
                do {
                    let userData = try JSONDecoder().decode(User.self, from: data)
                    completion(userData.public_repos ?? 0)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
}

extension MainViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        var timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let text = searchController.searchBar.text, !text.isEmpty, let url = URL(string: Constants.searchUsersEndpoint.rawValue + text) {
                URLSession.shared.dataTask(with: url) { (data, response, err) in
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
    }
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController!.searchResultsUpdater = self
        searchController!.obscuresBackgroundDuringPresentation = false
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

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? UserCell else {
            return UITableViewCell()
        }
        
        cell.userNameLabel.text = users[indexPath.row].login
        if let imgURL = users[indexPath.row].avatar_url {
            if let image = cache.object(forKey: imgURL as NSString) {
                cell.imgView.image = image
            } else {
                cell.imgView.downloadImageFrom(link: imgURL, contentMode: .scaleAspectFit, cache: cache)
            }
        }
        
        if let urlString = users[indexPath.row].url, let url = URL(string: urlString) {
            getRepos(url: url) { (repos) in
                DispatchQueue.main.async {
                    cell.repoLabel.text = "\(repos) Repos"
                }
            }
        }
        
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
