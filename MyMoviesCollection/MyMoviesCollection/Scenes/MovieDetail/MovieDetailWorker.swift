//
//  MovieDetailWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 06/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class MovieDetailWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
    private let coreData: PersistanceManager
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared, coreData: PersistanceManager = PersistanceManager.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
        self.coreData = coreData
    }
    
    func fetchGenres(_ completion: @escaping (MoviesApiClientResponse<GenresResponse>) -> ()) {
        apiClient.fetchMoviesGenres(completion)
    }
    
    func fetchBanner(posterUrl: String, _ completion: @escaping (MoviesApiClientResponse<UIImage>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
    func favoriteMovie(movie: Movie, _ completion: @escaping (Bool) -> ()) {
        do {
            try coreData.saveFavorite(movie: movie)
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func checkIfFavorite(movieId: Int32, _ completion: @escaping (Bool) -> ()) {
        let result = coreData.checkFavorite(id: movieId)
        completion(result)
    }
}
