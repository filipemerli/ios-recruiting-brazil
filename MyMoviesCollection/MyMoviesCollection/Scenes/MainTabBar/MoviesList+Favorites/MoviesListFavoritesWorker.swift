//
//  MoviesListWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class MoviesListFavoritesWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
    private let coreData: PersistanceManager
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared, coreData: PersistanceManager = PersistanceManager.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
        self.coreData = coreData
    }
    
    func fetchPopularMovies(page: Int, _ completion: @escaping (MoviesApiClientResponse<MoviesResponse>) -> ()) {
        apiClient.fetchMovies(page: page, completion)
    }
    
    func loadImage(posterUrl: String, _ completion: @escaping (MoviesApiClientResponse<UIImage>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
    func checkIfFavorite(movieId: Int32, _ completion: @escaping (Bool) -> ()) {
        let result = coreData.checkFavorite(id: movieId)
        completion(result)
    }
    
    func fetchFavorites(_ completion: @escaping (Result<[FavoriteMovie], ResponseError>) -> ()) {
        let manager = PersistanceManager()
        manager.fetchFavoritesList(completion)
    }
    
    func deleteFavorite(movieId: Int32, _ completion: @escaping (Bool) -> ()) {
        let result = coreData.deleteFavorite(id: movieId)
        completion(result)
    }
    
}
