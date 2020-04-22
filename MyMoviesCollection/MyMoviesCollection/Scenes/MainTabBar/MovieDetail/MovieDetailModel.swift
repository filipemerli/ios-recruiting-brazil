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
            let image: UIImage?
            
            init(image: UIImage?) {
                self.image = image
            }
        }
        
        struct MovieGenres {
            let genres: String
            
            init(genres: String) {
                self.genres = genres
            }
        }
        
        struct MovieFavButtonFeedback {
            let favButtonFeedback: Bool
            
            init(favButtonFeedback: Bool) {
                self.favButtonFeedback = favButtonFeedback
            }
        }
        
    }
}
