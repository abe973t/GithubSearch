//
//  User.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct User : Codable {
    let login : String?
    let avatar_url : String?
    let url : String?
    let html_url : String?
    let repos_url : String?
    let location: String?
    let email: String?
    let bio: String?
    let public_repos: Int?
    let followers: Int?
    let following: Int?
    let created_at: String?
}
