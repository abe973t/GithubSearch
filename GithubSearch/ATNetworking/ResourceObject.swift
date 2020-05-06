//
//  ResourceObject.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

public struct ResourceObject<T: Codable> {
    let method: HTTPMethod<Data>
    let url: URL
    let headers: [String: String]?
    let parse: (Data) -> T? = { data in
        return try? JSONDecoder().decode(T.self, from: data)
    }
}

extension ResourceObject {
    public init<T: Codable>(method: HTTPMethod<T>, url: URL, headers: [String: String]?) {
        self.headers = headers
        self.url = url
        self.method = method.map { json in
            try? JSONEncoder().encode(json)
        }
    }
}
