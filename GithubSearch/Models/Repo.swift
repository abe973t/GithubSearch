//
//  Repos.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct Repo: Codable {
    let name: String?
    let htmlUrl: String?
    let stargazersCount: Int?
    let forks: Int?
    
    enum CodingKeys: String, CodingKey {
        case name
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case forks
    }
}
