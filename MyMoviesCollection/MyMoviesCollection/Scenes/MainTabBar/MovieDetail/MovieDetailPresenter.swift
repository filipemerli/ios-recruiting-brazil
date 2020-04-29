//
//  MovieDetailPresenter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 14/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol MovieDetailPresentationLogic {
    func showMovieDetail(response: MovieDetail.ShowMovieDetail.ViewModel)
    func showMovieGenres(response: MovieDetail.ShowMovieDetail.MovieGenres)
    func showMovieBanner(response: MovieDetail.ShowMovieDetail.MovieBanner)
    func showFavoriteFeedback(response: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback)
    func showError(withMessage message: String)
}

final class MovieDetailPresenter: MovieDetailPresentationLogic {
    weak var viewController: (MovieDetailViewController)?
    
    func showMovieDetail(response: MovieDetail.ShowMovieDetail.ViewModel) {
        let viewModel = MovieDetail.ShowMovieDetail.ViewModel(movie: response.movie)
        viewController?.renderMovieDetail(viewModel: viewModel)
    }
    
    func showMovieGenres(response: MovieDetail.ShowMovieDetail.MovieGenres) {
        let viewModel = MovieDetail.ShowMovieDetail.MovieGenres(genres: response.genres)
        viewController?.renderMovieGenre(viewModel: viewModel)
    }
    
    func showMovieBanner(response: MovieDetail.ShowMovieDetail.MovieBanner) {
        let viewModel = MovieDetail.ShowMovieDetail.MovieBanner(image: response.image)
        viewController?.renderMovieBanner(viewModel: viewModel)
    }
    
    func showFavoriteFeedback(response: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback) {
        let viewModel = MovieDetail.ShowMovieDetail.MovieFavButtonFeedback(favButtonFeedback: response.favButtonFeedback)
        viewController?.renderFavoriteButtonFeedback(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()
        viewController?.showErrorAlert(with: message)
    }
    
}
