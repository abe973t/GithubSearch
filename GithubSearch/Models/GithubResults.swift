//
//  GithubResults.swift
//  GithubSearch
//
//  Created by mcs on 4/1/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

struct GithubResults: Codable {
    let totalCount: Int?
    let incompleteResults: Bool?
    let items: [User]?
    
    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}
