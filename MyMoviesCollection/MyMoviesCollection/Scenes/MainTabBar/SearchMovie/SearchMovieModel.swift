//
//  SearchMovieModel.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

enum SearchMovie {
    
    enum Fetch {
        
        struct Response {
            let movies: [Movie]
            
            init(movies: [Movie]) {
                self.movies = movies
            }
        }
        
        struct ViewModel {
            let movies: [Movie]
            
            init(movies: [Movie]) {
                self.movies = movies
            }
        }
    }
    
    enum MovieInfo {
        struct RequestBanner {
            let cell: UICollectionViewCell
            let posterUrl: String
            
            init(cell: UICollectionViewCell, posterUrl: String) {
                self.cell = cell
                self.posterUrl = posterUrl
            }
        }
        
        struct RequestFavorite {
            let cell: UICollectionViewCell
            let movieId: Int32
            
            init(cell: UICollectionViewCell, movieId: Int32) {
                self.cell = cell
                self.movieId = movieId
            }
        }
        
        struct ResponseBanner {
            let cell: UICollectionViewCell
            let image: UIImage?
            
            init(cell: UICollectionViewCell, image: UIImage?) {
                self.cell = cell
                self.image = image
            }
        }
        
        struct ResponseFavorite {
            let cell: UICollectionViewCell
            let isFavorite: Bool
            
            init(cell: UICollectionViewCell, isFavorite: Bool) {
                self.cell = cell
                self.isFavorite = isFavorite
            }
        }
        
        struct ViewModelBanner {
            let cell: UICollectionViewCell
            let image: UIImage?
            
            init(cell: UICollectionViewCell, image: UIImage?) {
                self.cell = cell
                self.image = image
            }
        }
        
        struct ViewModelFavorite {
            let cell: UICollectionViewCell
            let isFavorite: Bool
            
            init(cell: UICollectionViewCell, isFavorite: Bool) {
                self.cell = cell
                self.isFavorite = isFavorite
            }
        }
    }
    
}

