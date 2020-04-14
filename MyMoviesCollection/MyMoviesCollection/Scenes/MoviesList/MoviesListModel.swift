//
//  MoviesListModel.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

enum MoviesList {
    
    enum FetchMovies {
        struct RequestMovies {
            let page: Int
            
            init(page: Int) {
                self.page = page
            }
        }
        
        struct RequestFavorite {
            let id: Int
            
            init(id: Int) {
                self.id = id
            }
        }
        
        struct ResponseMovies {
            let movies: [Movie]
            let total: Int
            
            init(movies: [Movie], total: Int) {
                self.movies = movies
                self.total = total
            }
        }
        
        struct ViewModel {
            let movies: [Movie]
            
            init(movies: [Movie]) {
                self.movies = movies
            }
        }
    }
}
