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
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
    }
    
    func fetchGenres(_ completion: @escaping (MoviesApiClientResponse<GenresResponse>) -> ()) {
        apiClient.fetchMoviesGenres(completion)
    }
    
    func fetchBanner(posterUrl: String, _ completion: @escaping (MoviesApiClientResponse<UIImage>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
}
