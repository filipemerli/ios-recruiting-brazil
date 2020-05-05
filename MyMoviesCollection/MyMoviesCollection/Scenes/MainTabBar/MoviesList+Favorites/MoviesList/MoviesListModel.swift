//
//  MoviesListModel.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

enum MoviesList {
    
    enum Fetch {
        struct Request {
            let page: Int
            
            init(page: Int) {
                self.page = page
            }
        }
        
        struct Response {
            let movies: [Movie]
            let total: Int
            
            init(movies: [Movie], total: Int) {
                self.movies = movies
                self.total = total
            }
        }
        
        struct ViewModel {
            let movies: [Movie]
            let totalResults: Int
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
