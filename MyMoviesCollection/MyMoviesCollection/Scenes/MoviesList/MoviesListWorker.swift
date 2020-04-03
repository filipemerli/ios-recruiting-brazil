//
//  MoviesListWorker.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

class MoviesListWorker {
    
    private let apiClient: MoviesAPIClient
 
    init(apiClient: MoviesAPIClient = MoviesAPIClient.shared) {
        self.apiClient = apiClient
    }
    
    func fetchPopularMovies(page: Int, _ completion: @escaping (MoviesApiClientResponse<MoviesResponse>) -> ()) {
        apiClient.fetchMovies(page: page, completion)
    }
    
}
