//
//  MovieDetailModel.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 14/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

enum MovieDetail {
    
    enum ShowMovieDetail {
        
        struct ViewModel {
            let movie: Movie
            
            init(movie: Movie) {
                self.movie = movie
            }
        }
        
        struct MovieBanner {
            let movieBanner: UIImage
            
            init(movieBanner: UIImage) {
                self.movieBanner = movieBanner
            }
        }
        
        struct MovieGenres {
            let genres: String
            
            init(genres: String) {
                self.genres = genres
            }
        }
        
        
    }
}
