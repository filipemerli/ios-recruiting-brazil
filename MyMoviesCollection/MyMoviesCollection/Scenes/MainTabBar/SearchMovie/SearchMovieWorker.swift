//
//  SearchMovieWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

final class SearchMovieWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
    }
    
    func fetchSearchMovies(page: Int, keyWord: String, _ completion: @escaping (Result<MoviesResponse, ResponseError>) -> ()) {
        apiClient.fetchSearchMovie(page: page, text: keyWord, completion: completion)
    }
    
    func loadImage(posterUrl: String, _ completion: @escaping (Result<UIImage, ResponseError>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
}
