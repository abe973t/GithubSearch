//
//  URLRequest+init.swift
//  iTunesRSS
//
//  Created by mcs on 4/21/20.
//  Copyright © 2020 MCS. All rights reserved.
//

import Foundation

extension URLRequest {
    init<T: Decodable>(resource: ResourceObject<T>) {
        self.init(url: resource.url)
        httpMethod = resource.method.methodString
        
        switch resource.method {
        case .post(let data), .put(let data):
            httpBody = data
        case .get, .delete:
            break
        }
    }
    
    init(resource: ResourceData) {
        self.init(url: resource.url)
        httpMethod = resource.method.methodString
        
        switch resource.method {
        case .get: break
        case .post(let data):
            httpBody = data
        case .put(let data):
            httpBody = data
        default:
            break
        }        
    }
}
