//
//  MovieDetailRouter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 06/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

@objc protocol MovieDetailRoutingLogic {

}

protocol MovieDetailDataPassing {
    var dataStore: MovieDetailDataStore? { get }
}

class MovieDetailRouter: NSObject, MovieDetailRoutingLogic, MovieDetailDataPassing {
    
    weak var viewController: MovieDetailViewController?
    var dataStore: MovieDetailDataStore?
    
}
