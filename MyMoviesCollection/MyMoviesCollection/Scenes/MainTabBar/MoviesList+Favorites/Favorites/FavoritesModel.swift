//
//  FavoritesModel.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import UIKit

enum Favorites {
    
    enum Fetch {
        
        struct Request {
        }
        
        struct Response {
            let movies: [FavoriteMovie]
            
            init(movies: [FavoriteMovie]) {
                self.movies = movies
            }
        }
        
        struct ViewModel {
            let movies: [FavoriteMovie]
            
            init(movies: [FavoriteMovie]) {
                self.movies = movies
            }
        }
    }
    
    enum MovieInfo {
        struct RequestBanner {
            let cell: UITableViewCell
            let posterUrl: String
            
            init(cell: UITableViewCell, posterUrl: String) {
                self.cell = cell
                self.posterUrl = posterUrl
            }
        }
        
        struct ResponseBanner {
            let cell: UITableViewCell
            let image: UIImage
            
            init(cell: UITableViewCell, image: UIImage) {
                self.cell = cell
                self.image = image
            }
        }
        
        struct ViewModelBanner {
            let cell: UITableViewCell
            let image: UIImage
            
            init(cell: UITableViewCell, image: UIImage) {
                self.cell = cell
                self.image = image
            }
        }
    }
    
    enum DeleteFavorite {
        
        struct Request {
            let movieId: Int32
            let indexPath: IndexPath
            
            init(movieId: Int32, indexPath: IndexPath) {
                self.movieId = movieId
                self.indexPath = indexPath
            }
        }
        
        struct Response {
            let success: Bool
            let indexPath: IndexPath?
            
            init(success: Bool, indexPath: IndexPath) {
                self.success = success
                self.indexPath = indexPath
            }
        }
        
        struct ViewModel {
            let movieToDelete: Bool
            let indexToDelete: IndexPath
            
            init(movieToDelete: Bool, indexToDelete: IndexPath) {
                self.movieToDelete = movieToDelete
                self.indexToDelete = indexToDelete
            }
        }
    }
    
}
