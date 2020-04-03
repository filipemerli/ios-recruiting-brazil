//
//  MoviesListPresenter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol MoviesListPresentationLogic {
    func showMoviesList(response: MoviesList.Fetch.Response)
    func showError(withMessage message: String)
}

class MoviesListPresenter: MoviesListPresentationLogic {
    weak var viewController: (MoviesListViewController)?
    
    func showMoviesList(response: MoviesList.Fetch.Response) {
        let viewModel = MoviesList.Fetch.ViewModel(movies: response.movies)
        viewController?.renderMoviesList(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()
        viewController?.showErrorAlert(with: message)
    }
    
}
