//
//  ProfileViewController.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var searchController: UISearchController!
    var user: User!
    
    let aviImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.backgroundColor = .systemRed
        return img
    }()
    
    let userNameLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let emailLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    let locationLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let joinDateLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let followersLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let followingLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let bioLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.sizeToFit()
        return lbl
    }()
    
    let tableView: UITableView = {
        let tblView = UITableView()
        tblView.translatesAutoresizingMaskIntoConstraints = false
        tblView.backgroundColor = .systemRed
        return tblView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        aviImage.downloadImageFrom(link: user.avatar_url!, contentMode: .scaleAspectFit)
        userNameLabel.text = user.login!
        emailLabel.text = user.url!     // email not available
        locationLabel.text = user.location ?? ""
        joinDateLabel.text = user.created_at ?? ""
        followersLabel.text = "\(user.followers!) followers"
        followingLabel.text = "\(user.following!) following"
        bioLabel.text = user.bio ?? ""
    }
    
    func updateFollowers() {
        let url = URL(string: user.followers_url!)!
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
                do {
                    let followers = try JSONDecoder().decode([User].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.followersLabel.text = "\(followers.count) followers"
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
    }
    
    func updateFollowing() {
        let url = URL(string: user.following_url!)!
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let data = data {
                do {
                    let following = try JSONDecoder().decode([User].self, from: data)
                    
                    DispatchQueue.main.async {
                        self.followingLabel.text = "\(following.count) followers"
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }.resume()
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
            userNameLabel.heightAnchor.constraint(equalToConstant: 32),
            
            emailLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            emailLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            emailLabel.heightAnchor.constraint(equalToConstant: 32),
            
            locationLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15),
            locationLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            locationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            locationLabel.heightAnchor.constraint(equalToConstant: 32),
            
            joinDateLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 15),
            joinDateLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            joinDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            joinDateLabel.heightAnchor.constraint(equalToConstant: 32),
            
            followersLabel.topAnchor.constraint(equalTo: joinDateLabel.bottomAnchor, constant: 15),
            followersLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            followersLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            followersLabel.heightAnchor.constraint(equalToConstant: 32),
            
            followingLabel.topAnchor.constraint(equalTo: followersLabel.bottomAnchor, constant: 15),
            followingLabel.leadingAnchor.constraint(equalTo: aviImage.trailingAnchor, constant: 10),
            followingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            followingLabel.heightAnchor.constraint(equalToConstant: 32),
            
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

extension ProfileViewController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
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
