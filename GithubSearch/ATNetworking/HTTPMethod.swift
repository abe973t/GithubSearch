//
//  HTTPMethod.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

public enum HTTPMethod<Body> {
    case get
    case post(Body)
    case put(Body)
    case delete
}

extension HTTPMethod {
    var methodString: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
    
    func map<B: Encodable>(_: (Body) -> B?) -> HTTPMethod<B> {
        switch self {
        case .get:
            return .get
        case .post(let body):
            return .post(body as! B)
        case .put(let body):
            return .put(body as! B)
        case .delete:
            return .delete
        }
    }
}
