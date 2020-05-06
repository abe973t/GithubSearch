//
//  ProfileViewController.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit
import SafariServices

class ProfileViewController: UIViewController {
    
    var searchController: UISearchController!
    var user: User!
    var repos = [Repo]()
    var filteredRepos = [Repo]()
    var searchMode = false
    var cache: NSCache<NSString, UIImage>!
    
    let aviImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let joinDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let followersLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let followingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        return tblView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        if user == nil {
            let alert = UIAlertController(title: "Error", message: "API rate limit exceeded. (But here\'s the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        }
        
        addViews()
        aviImage.downloadImageFrom(link: user?.avatarUrl ?? "", contentMode: .scaleAspectFit, cache: cache)
        userNameLabel.text = "User: \(user?.login ?? "N/A")"
        emailLabel.text = "Email: \(user?.email ?? "N/A")"
        locationLabel.text = "Location: \(user?.location ?? "N/A")"
        joinDateLabel.text = "Joined: " + convertDateFormatter(date: user?.createdAt ?? "N/A")
        followersLabel.text = "\(user?.followers ?? 0) followers"
        followingLabel.text = "following \(user?.following ?? 0)"
        bioLabel.text = user?.bio ?? ""
        
        tableView.register(RepoCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchRepos()
    }
    
    func convertDateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        

        guard let convertedDate = dateFormatter.date(from: date) else {
            return ""
        }

        dateFormatter.dateFormat = "MMM dd, yyyy"
        let timeStamp = dateFormatter.string(from: convertedDate)

        return timeStamp
    }
    
    func fetchRepos() {
        if let urlString = user?.reposUrl, let url = URL(string: urlString) {
            let resource = ResourceObject<[Repo]>(method: HTTPMethod<[Repo]>.get, url: url, headers: nil)
            
            NetworkingManager.shared.loadObject(resource: resource) { (reposResult, request, err) in
                if let repos = reposResult {
                    self.repos = repos
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } else {
                    // alert
                }
            }
        }
    }
    
    func addViews() {
        configureSearchBar()
        view.addSubview(aviImage)
        view.addSubview(userNameLabel)
        view.addSubview(emailLabel)
        view.addSubview(locationLabel)
        view.addSubview(joinDateLabel)
        view.addSubview(followersLabel)
        view.addSubview(followingLabel)
        view.addSubview(bioLabel)
        view.addSubview(tableView)
        tableView.tableHeaderView = searchController.searchBar

        addContraints()
    }
    
    func addContraints() {
        NSLayoutConstraint.activate([
            aviImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            aviImage.widthAnchor.constraint(equalToConstant: 200),
            aviImage.heightAnchor.constraint(equalToConstant: 150),
            aviImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            
            userNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            userNameLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            emailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            locationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            joinDateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            joinDateLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            joinDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            followersLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 15),
            followersLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            followersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            followingLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 15),
            followingLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            followingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            bioLabel.topAnchor.constraint(equalTo: followingLabel.bottomAnchor, constant: 10),
            bioLabel.leadingAnchor.constraint(equalTo: aviImage.leadingAnchor),
            bioLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            tableView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - SearchBar Extensions
extension ProfileViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            searchMode = true
            
            filteredRepos = repos.filter({ (repo) -> Bool in
                return (repo.name?.lowercased().contains(text.lowercased())) ?? false
            })
        } else {
            searchMode = false
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchMode = false
    }
    
    func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.placeholder = "Search Repos"
    }
}

// MARK: - TableView Extensions
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMode ? filteredRepos.count : repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? RepoCell else {
            return UITableViewCell()
        }
        
        let repo = searchMode ? filteredRepos[indexPath.row] : repos[indexPath.row]
        
        cell.userNameLabel.text = repo.name
        cell.forksLabel.text = "\(repo.forks ?? 0) Forks"
        cell.starsLabel.text = "\(repo.stargazersCount ?? 0) Stars"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.isActive = false
        let repo = searchMode ? filteredRepos[indexPath.row] : repos[indexPath.row]
        
        if let urlString = repo.htmlUrl, let url = URL(string: urlString) {
            let safari = SFSafariViewController(url: url)
            navigationController?.present(safari, animated: true, completion: nil)
        }
    }
}
