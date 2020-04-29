//
//  MovieDetailWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 06/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

final class MovieDetailWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
    }
    
    func fetchGenres(_ completion: @escaping (Result<GenresResponse, ResponseError>) -> ()) {
        apiClient.fetchMoviesGenres(completion)
    }
    
    func loadImage(posterUrl: String, _ completion: @escaping (Result<UIImage, ResponseError>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
}
