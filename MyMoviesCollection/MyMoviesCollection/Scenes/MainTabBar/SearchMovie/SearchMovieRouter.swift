//
//  SearchMovieRouter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

@objc protocol SearchMovieRoutingLogic {
    func routeToDetail(source: SearchMovieViewController)
}

protocol SearchMovieDataPassing {
    var dataStore: SearchMovieDataStore? { get set }
}

class SearchMovieRouter: NSObject, SearchMovieRoutingLogic, SearchMovieDataPassing {
    
    weak var viewController: SearchMovieViewController?
    var dataStore: SearchMovieDataStore?
    
    // MARK: Routing
    
    func routeToDetail(source: SearchMovieViewController) {
        let destinationVC = MovieDetailViewController()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToDetail(source: dataStore!, destination: &destinationDS)
        navigateToDetail(source: source, destination: destinationVC)
    }
    
    // MARK: Navigation
    
    func navigateToDetail(source: SearchMovieViewController, destination: MovieDetailViewController) {
        source.show(destination, sender: nil)
    }
    
    // MARK: Passing data
    
    func passDataToDetail(source: SearchMovieDataStore, destination: inout MovieDetailDataStore) {
        guard let selectedMovie = viewController?.movieToPresent else { return } // TO DO: ERROR
        destination.movie = selectedMovie
    }
    
}
