//
//  GithubResults.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct GithubResults : Codable {
    let total_count : Int?
    let incomplete_results : Bool?
    let items: [User]?
}
