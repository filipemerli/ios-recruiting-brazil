//
//  FavoritesWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class FavoritesWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
    }
    
    func loadImage(posterUrl: String, _ completion: @escaping (Result<UIImage, ResponseError>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
    func fetchFavorites(_ completion: @escaping (Result<[FavoriteMovie], ResponseError>) -> ()) {
        let dataManager = PersistanceManager()
        dataManager.fetchFavoritesList(completion)
    }
    
    func deleteFavorite(movieId: Int32, _ completion: @escaping (Bool) -> ()) {
        let dataManager = PersistanceManager()
        let result = dataManager.deleteFavorite(id: movieId)
        completion(result)
    }
    
}
