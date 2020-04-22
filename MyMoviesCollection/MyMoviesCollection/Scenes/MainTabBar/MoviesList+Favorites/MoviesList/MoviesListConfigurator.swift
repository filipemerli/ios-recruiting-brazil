//
//  MoviesListConfigurator.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

class MoviesListConfigurator {
    
    static let shared = MoviesListConfigurator()
    
    func configure(viewController: MoviesListViewController) {
        let interactor = MoviesListInteractor()
        let presenter = MoviesListPresenter()
        let router = MoviesListRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
}
