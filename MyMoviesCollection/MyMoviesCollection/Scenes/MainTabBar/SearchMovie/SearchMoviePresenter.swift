//
//  SearchMoviePresenter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol SearchMoviePresentationLogic {
    func showMoviesList(response: SearchMovie.Fetch.Response)
    func showMovieBanner(response: SearchMovie.MovieInfo.ResponseBanner)
    func showFavoriteFeedback(response: SearchMovie.MovieInfo.ResponseFavorite)
    func showError(withMessage message: String)
}

class SearchMoviePresenter: SearchMoviePresentationLogic {
    weak var viewController: (SearchMovieViewController)?
    
    func showMoviesList(response: SearchMovie.Fetch.Response) {
        let viewModel = SearchMovie.Fetch.ViewModel(movies: response.movies, keyWord: response.keyWord, totalResults: response.totalResults)
        viewController?.renderMoviesList(viewModel: viewModel)
    }
    
    func showMovieBanner(response: SearchMovie.MovieInfo.ResponseBanner) {
        let viewModel = SearchMovie.MovieInfo.ViewModelBanner(cell: response.cell, image: response.image)
        viewController?.renderMovieBanner(viewModel: viewModel)
    }
    
    func showFavoriteFeedback(response: SearchMovie.MovieInfo.ResponseFavorite) {
        let viewModel = SearchMovie.MovieInfo.ViewModelFavorite(cell: response.cell, isFavorite: response.isFavorite)
        viewController?.renderFavoriteFeedback(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()  **** TO DO
        viewController?.showErrorAlert(with: message)
    }
    
}
