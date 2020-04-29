//
//  MovieDetailConfigurator.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 14/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

final class MovieDetailConfigurator {
    
    static let shared = MovieDetailConfigurator()
    
    func configure(viewController: MovieDetailViewController) {
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        let router = MovieDetailRouter()
        let dataManager = PersistanceManager()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        interactor.dataManager = dataManager
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
}
