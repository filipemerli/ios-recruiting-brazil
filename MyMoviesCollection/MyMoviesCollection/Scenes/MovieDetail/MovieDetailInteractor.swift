//
//  MovieDetailInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 06/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol MovieDetailBusinessLogic {
    //func fetchPopularMovies(request: MoviesList.FetchMovies.RequestMovies)
    //func presentDetailVC(movie: Movie)
}

protocol MovieDetailDataStore {
    var movie: Movie! { get set }
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    
    var movie: Movie!
    var presenter: MovieDetailPresentationLogic?
    private var worker: MovieDetailWorker?
    
    init (worker: MovieDetailWorker = MovieDetailWorker()) {
        self.worker = worker
    }
    
    // MARK: - Get movie
    
    func fetchGenres() {
//        worker?.fetchPopularMovies(page: request.page) { resultMov in
//            switch resultMov {
//            case .error(let errorMov):
//                self.presenter?.showError(withMessage: errorMov.localizedDescription)
//            case .success(let responseMov):
//                let response = MoviesList.FetchMovies.ResponseMovies(movies: responseMov.movies, total: responseMov.totalResults)
//                self.presenter?.showMoviesList(response: response)
//            }
//        }
    }
    
    
}
