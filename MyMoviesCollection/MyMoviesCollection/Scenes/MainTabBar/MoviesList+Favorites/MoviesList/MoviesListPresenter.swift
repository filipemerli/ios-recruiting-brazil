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
    func showMovieBanner(response: MoviesList.MovieInfo.ResponseBanner)
    func showFavoriteFeedback(response: MoviesList.MovieInfo.ResponseFavorite)
    func showError(withMessage message: String)
}

final class MoviesListPresenter: MoviesListPresentationLogic {
    weak var viewController: (MoviesListViewController)?
    
    func showMoviesList(response: MoviesList.Fetch.Response) {
        let viewModel = MoviesList.Fetch.ViewModel(movies: response.movies)
        viewController?.renderMoviesList(viewModel: viewModel)
    }
    
    func showMovieBanner(response: MoviesList.MovieInfo.ResponseBanner) {
        let viewModel = MoviesList.MovieInfo.ViewModelBanner(cell: response.cell, image: response.image)
        viewController?.renderMovieBanner(viewModel: viewModel)
    }
    
    func showFavoriteFeedback(response: MoviesList.MovieInfo.ResponseFavorite) {
        let viewModel = MoviesList.MovieInfo.ViewModelFavorite(cell: response.cell, isFavorite: response.isFavorite)
        viewController?.renderFavoriteFeedback(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()  **** TO DO
        viewController?.showErrorAlert(with: message)
    }
    
}
