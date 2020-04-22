//
//  SearchMovieWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

class SearchMovieWorker {
    
    private let apiClient: MoviesAPIClient
    private let loadImage: LoadImageWithCache
    private let coreData: PersistanceManager
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared, loadImage: LoadImageWithCache = LoadImageWithCache.shared, coreData: PersistanceManager = PersistanceManager.shared) {
        self.apiClient = apiClient
        self.loadImage = loadImage
        self.coreData = coreData
        
    }
    
    func fetchSearchMovies(keyWord: String, _ completion: @escaping (Result<MoviesResponse, ResponseError>) -> ()) {
        apiClient.fetchSearchMovie(text: keyWord, completion: completion)
    }
    
    func loadImage(posterUrl: String, _ completion: @escaping (Result<UIImage, ResponseError>) -> ()) {
        loadImage.downloadMovieAPIImage(posterUrl: posterUrl, completion)
    }
    
    func checkIfFavorite(movieId: Int32, _ completion: @escaping (Bool) -> ()) {
        let result = coreData.checkFavorite(id: movieId)
        completion(result)
    }
    
}
