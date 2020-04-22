//
//  MoviesListRouter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

@objc protocol MoviesListRoutingLogic {
    func routeToDetail(source: MoviesListViewController)
    func routeToSearch(source: MoviesListViewController)
}

protocol MoviesListDataPassing {
    var dataStore: MoviesListDataStore? { get }
}

class MoviesListRouter: NSObject, MoviesListRoutingLogic, MoviesListDataPassing {
    
    weak var viewController: MoviesListViewController?
    var dataStore: MoviesListDataStore?
    
    // MARK: Routing
    
    func routeToDetail(source: MoviesListViewController) {
        let destinationVC = MovieDetailViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetail(source: source, destination: destinationVC)
    }
    
    func routeToSearch(source: MoviesListViewController) {
        let destinationVC = SearchMovieViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToSearch(source: dataStore!, destination: &destinationDS)
        navigateToSearch(source: source, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetail(source: MoviesListViewController, destination: MovieDetailViewController) {
        source.show(destination, sender: nil)
    }
    
    func navigateToSearch(source: MoviesListViewController, destination: SearchMovieViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToDetail(source: MoviesListDataStore, destination: inout MovieDetailDataStore) {
        guard let selectedMovie = viewController?.movieToPresent else { return } // TO DO: ERROR
        destination.movie = selectedMovie
    }
    
    func passDataToSearch(source: MoviesListDataStore, destination: inout SearchMovieDataStore) {
        guard let keyWord = viewController?.keyWord else { return } // TO DO: ERROR
        destination.keyWord = keyWord
    }
    
}
