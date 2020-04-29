//
//  SearchMovieConfigurator.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

final class SearchMovieConfigurator {
    
    static let shared = SearchMovieConfigurator()
    
    func configure(viewController: SearchMovieViewController) {
        let interactor = SearchMovieInteractor()
        let presenter = SearchMoviePresenter()
        let router = SearchMovieRouter()
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
