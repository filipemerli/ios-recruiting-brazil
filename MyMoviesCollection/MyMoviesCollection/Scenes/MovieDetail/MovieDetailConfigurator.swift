//
//  MovieDetailConfigurator.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 14/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

class MovieDetailConfigurator {
    
    static let shared = MovieDetailConfigurator()
    
    func configure(viewController: MovieDetailViewController) {
        let interactor = MovieDetailInteractor()
        let presenter = MovieDetailPresenter()
        let router = MovieDetailRouter()
        
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    
}
