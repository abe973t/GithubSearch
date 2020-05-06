//
//  UIImageView+downloadImage.swift
//  CollectionViewProgrammatically
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit
import ATNetworking

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode, cache: NSCache<NSString, UIImage>) {
        if let cachedImg = cache.object(forKey: link as NSString) {
            self.image = cachedImg
        } else if let url = URL(string: link) {
            let resource = ResourceData(url: url, method: .get, headers: nil)
            
            NetworkingManager.shared.loadData(resource: resource) { (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        if let img = UIImage(data: data) {
                            self.image = img
                            cache.setObject(img, forKey: link as NSString)
                        } else {
                            print("unable to decode image")
                        }
                    }
                case .failure(_):
                    print("invalid image url")
                }
            }
        }
    }
}
