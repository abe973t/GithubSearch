//
//  Repos.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct Repo: Codable {
    let name : String?
    let html_url : String?
    let stargazers_count : Int?
    let forks : Int?
}
