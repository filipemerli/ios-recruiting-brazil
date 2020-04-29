//
//  LoadImageWithCache.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 13/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation
import UIKit

final class LoadImageWithCache {

    // MARK: - Constants

    fileprivate let imageCache = NSCache<NSString, AnyObject>()
    static var shared = LoadImageWithCache()
    
    // MARK: - Class Functions
    
    func downloadMovieAPIImage(posterUrl: String, _ completion: @escaping (Result<UIImage, ResponseError>) -> Void) {
        let urlConcat = "https://image.tmdb.org/t/p/w500" + posterUrl
        guard let url = URL(string: urlConcat) else {
            completion(Result.failure(ResponseError.rede))
            return
        }
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            completion(Result.success(imageFromCache))
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let imageToCache = UIImage(data: data) else {
                completion(Result.failure(ResponseError.rede))
                return
            }
            self.imageCache.setObject(imageToCache, forKey: urlConcat as NSString)
            completion(Result.success(imageToCache))
        }).resume()
    }
    
}
