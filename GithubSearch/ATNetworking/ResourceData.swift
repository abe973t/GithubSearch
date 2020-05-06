//
//  DataObject.swift
//  iTunesRSS
//
//  Created by mcs on 4/23/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

public struct ResourceData {
    let url: URL
    let method: HTTPMethod<Data>
    let parse: (Data) -> Void
    let headers: [String: String]?
}

extension ResourceData {
    public init(url: URL, method: HTTPMethod<Data>, headers: [String: String]?) {
        self.url = url
        self.method = method
        self.parse = { data in }
        self.headers = headers
    }
}
