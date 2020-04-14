//
//  MovieDetailWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 06/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

class MovieDetailWorker {
    
    private let apiClient: MoviesAPIClient
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchGenres(page: Int, _ completion: @escaping (MoviesApiClientResponse<GenresResponse>) -> ()) {
        apiClient.fetchMoviesGenres(completion)
    }
    
}
