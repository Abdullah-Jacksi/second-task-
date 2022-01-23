//
//  DownloadImage.swift
//  second task
//
//  Created by abd on 21/01/2022.
//

import Foundation
import UIKit


extension UIImageView {
    func downloadImage(imageUrl: String) -> URLSessionDataTask? {
        guard let url = URL(string: imageUrl) else { return nil }
        
        image = nil
        
        //        let downloadedImage = ImageCache.imageCache.object(forKey: imageUrl as AnyObject)
        //        if let cachedImage = downloadedImage as? UIImage {
        //            print("Image get from cache \(imageUrl)")
        //            self.image = cachedImage
        //            return nil
        //        } else {
        var task = URLSessionDataTask()
        
        task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if error == nil {
                    guard let myData = data else { return }
                    if let imageToCache = UIImage(data: myData) {
                        //                                ImageCache.imageCache.setObject(imageToCache, forKey: imageUrl as AnyObject)
                        self.image = imageToCache
                    }
                    else {
                        self.image = UIImage(named: "user")
                    }
                } else {
                    self.image = UIImage(named: "user")
                }
            }
        }
        task.resume()
        return task
        //        }
    }
}
