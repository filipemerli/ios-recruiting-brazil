//
//  FavoritesConfigurator.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

final class FavoritesConfigurator {
    
    static let shared = FavoritesConfigurator()
    
    func configure(viewController: FavoritesViewController) {
        let interactor = FavoritesInteractor()
        let presenter = FavoritesPresenter()
        let router = FavoritesRouter()
        let dataManager = PersistanceManager()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        interactor.dataManager = dataManager
        router.viewController = viewController
        router.dataStore = interactor
    }
    
}
