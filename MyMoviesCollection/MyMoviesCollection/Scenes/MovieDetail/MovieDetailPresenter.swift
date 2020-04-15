//
//  MovieDetailPresenter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 14/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol MovieDetailPresentationLogic {
    func showMovieDetail(viewModel: MovieDetail.ShowMovieDetail.ViewModel)
    func showMovieGenres(viewModel: MovieDetail.ShowMovieDetail.MovieGenres)
    func showMovieBanner(viewModel: MovieDetail.ShowMovieDetail.MovieBanner)
    func showFavoriteFeedback(viewModel: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback)
    func showError(withMessage message: String)
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    weak var viewController: (MovieDetailViewController)?
    
    func showMovieDetail(viewModel: MovieDetail.ShowMovieDetail.ViewModel) {
        let viewModel = MovieDetail.ShowMovieDetail.ViewModel(movie: viewModel.movie)
        viewController?.renderMovieDetail(viewModel: viewModel)
    }
    
    func showMovieGenres(viewModel: MovieDetail.ShowMovieDetail.MovieGenres) {
        let viewModel = MovieDetail.ShowMovieDetail.MovieGenres(genres: viewModel.genres)
        viewController?.renderMovieGenre(viewModel: viewModel)
    }
    
    func showMovieBanner(viewModel: MovieDetail.ShowMovieDetail.MovieBanner) {
        let viewModel = MovieDetail.ShowMovieDetail.MovieBanner(movieBanner: viewModel.movieBanner)
        viewController?.renderMovieBanner(viewModel: viewModel)
    }
    
    func showFavoriteFeedback(viewModel: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback) {
        let viewModel = MovieDetail.ShowMovieDetail.MovieFavButtonFeedback(favButtonFeedback: viewModel.favButtonFeedback)
        viewController?.renderFavoriteButtonFeedback(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()
        viewController?.showErrorAlert(with: message)
    }
    
}
