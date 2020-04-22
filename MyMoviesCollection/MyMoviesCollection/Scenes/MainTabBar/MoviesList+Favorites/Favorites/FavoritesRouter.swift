//
//  FavoritesRouter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

@objc protocol FavoritesRoutingLogic {
    //func routeFavorites(source: FavoritesViewController)
}

protocol FavoritesDataPassing {
    //var dataStore: FavoritesDataStore? { get }
}

class FavoritesRouter: NSObject, FavoritesRoutingLogic, FavoritesDataPassing {
    
    weak var viewController: FavoritesViewController?
    var dataStore: FavoritesDataStore?
    
    
}
