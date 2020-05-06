//
//  NetworkManagerViewController.swift
//  NetworkManager
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

public class NetworkingManager {
    public static let shared = NetworkingManager()
    private init() {}
    
    public func loadData(resource: ResourceData, completion: @escaping ((Result<Data, Error>) -> ())) {
        let request = URLRequest(resource: resource)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            
            if let data = data {
                completion(.success(data))
            }
        }.resume()
    }
    
    public func loadObject<Codable>(resource: ResourceObject<Codable>, completion: @escaping (Codable?, URLRequest?, Error?) -> ()) {
        let request = URLRequest(resource: resource)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(nil, request, error)
                return
            }
            
            completion(data.flatMap(resource.parse), request, nil)
        }.resume()
    }
}
