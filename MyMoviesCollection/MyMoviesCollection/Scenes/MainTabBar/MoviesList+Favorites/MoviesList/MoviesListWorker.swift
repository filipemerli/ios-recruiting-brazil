//
//  MoviesListWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class MoviesListWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
    
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
        
    }
    
    func fetchPopularMovies(page: Int, _ completion: @escaping (Result<MoviesResponse, ResponseError>) -> ()) {
        apiClient.fetchMovies(page: page, completion)
    }
    
    func loadImage(posterUrl: String, _ completion: @escaping (Result<UIImage, ResponseError>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
    func checkIfFavorite(movieId: Int32, _ completion: @escaping (Bool) -> ()) {
        let dataManager = PersistanceManager()
        let result = dataManager.checkFavorite(id: movieId)
        completion(result)
    }
    
}
