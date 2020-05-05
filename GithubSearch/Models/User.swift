//
//  User.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String?
    let avatarUrl: String?
    let url: String?
    let htmlUrl: String?
    let reposUrl: String?
    let location: String?
    let email: String?
    let bio: String?
    let publicRepos: Int?
    let followers: Int?
    let following: Int?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarUrl = "avatar_url"
        case url
        case htmlUrl = "html_url"
        case reposUrl = "repos_url"
        case location
        case email
        case bio
        case publicRepos = "public_repos"
        case followers
        case following
        case createdAt = "created_at"
    }
}
