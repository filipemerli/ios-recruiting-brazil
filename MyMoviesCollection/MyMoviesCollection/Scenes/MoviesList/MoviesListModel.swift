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
            
            init(page: Int, limit: Int) {
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
            
            init(movies: [Movie]) {
                self.movies = movies
            }
        }
    }
    
//    enum Banner {
//        struct Request {
//            let cell: UITableViewCell
//            let url: String
//
//            init(url: String, cell: UITableViewCell) {
//                self.url = url
//                self.cell = cell
//            }
//        }
//
//        struct Response {
//            let image: UIImage
//            let cell: UITableViewCell
//
//            init(image: UIImage, cell: UITableViewCell) {
//                self.image = image
//                self.cell = cell
//            }
//        }
//
//        struct ViewModel {
//            let image: UIImage
//            let cell: UITableViewCell
//
//            init(image: UIImage, cell: UITableViewCell) {
//                self.image = image
//                self.cell = cell
//            }
//        }
//    }
}
