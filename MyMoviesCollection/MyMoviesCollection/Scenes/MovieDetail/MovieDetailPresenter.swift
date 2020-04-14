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
    func showError(withMessage message: String)
}

class MovieDetailPresenter: MovieDetailPresentationLogic {
    weak var viewController: (MovieDetailViewController)?
    
    func showMovieDetail(viewModel: MovieDetail.ShowMovieDetail.ViewModel) {
        let viewModel = MovieDetail.ShowMovieDetail.ViewModel(movie: viewModel.movie)
        viewController?.renderMovieGenre(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()
        viewController?.showErrorAlert(with: message)
    }
    
}
