//
//  MoviesListRouter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

@objc protocol MoviesListRoutingLogic {
  func navigateToDetail(source: MoviesListViewController, destination: MovieDetailViewController)
}

protocol MoviesListDataPassing {
    var dataStore: MoviesListDataStore? { get }
}

class MoviesListRouter: NSObject, MoviesListRoutingLogic, MoviesListDataPassing {
  
    weak var viewController: MoviesListViewController?
    var dataStore: MoviesListDataStore?
    
    func navigateToDetail(source: MoviesListViewController, destination: MovieDetailViewController) {
        source.show(destination, sender: nil)
    }
    
//    func passDataToSomewhere(source: MoviesListDataStore, destination: inout MoviesDetailDataStore) {
//      destination.name = source.name
//    }
    
}
