//
//  EndPoints.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

enum Endpoints<T: MoviesAPIClient> {
    case popularMovies
    case searchMovies
    case genders

    var url: URL {
        let path: String
        
        switch self {
        case .popularMovies:
            path = "movie/popular"
        case .searchMovies:
            path = "search/movie"
        case .genders:
            path = "genre/movie/list"
        }
        
        return URL(string: T.baseURL + path) ?? URL(fileURLWithPath: "https://")
    }
}
