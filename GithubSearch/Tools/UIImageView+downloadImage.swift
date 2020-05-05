//
//  UIImageView+downloadImage.swift
//  CollectionViewProgrammatically
//
//  Created by mcs on 1/27/20.
//  Copyright © 2020 mcs. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadImageFrom(link: String, contentMode: UIView.ContentMode, cache: NSCache<NSString, UIImage>) {
        if let cachedImg = cache.object(forKey: link as NSString) {
            self.image = cachedImg
        } else if let url = URL(string: link) {
            URLSession.shared.dataTask(with: url) { (data, resp, err) in
                DispatchQueue.main.async {
                    self.contentMode =  contentMode
                    
                    if let data = data, let img = UIImage(data: data) {
                        self.image = img
                        cache.setObject(img, forKey: link as NSString)
                    } else {
                        print("unable to decode image")
                    }
                }
            }.resume()
        }
    }
}
