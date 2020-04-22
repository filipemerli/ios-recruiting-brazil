//
//  FavoritesConfigurator.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

class FavoritesConfigurator {
    
    static let shared = FavoritesConfigurator()
    
    func configure(viewController: FavoritesViewController) {
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter()
        let router = FavoritesRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
}
