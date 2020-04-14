//
//  MoviesListInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

protocol MoviesListBusinessLogic {
    func fetchPopularMovies(request: MoviesList.FetchMovies.RequestMovies)
}

protocol MoviesListDataStore {
    //var movie: Movie { get set }
}

class MoviesListInteractor: MoviesListBusinessLogic, MoviesListDataStore {

    var presenter: MoviesListPresentationLogic?
    private var worker: MoviesListWorker?
    
    init (worker: MoviesListWorker = MoviesListWorker()) {
        self.worker = worker
    }
    
    func fetchPopularMovies(request: MoviesList.FetchMovies.RequestMovies) {
        worker?.fetchPopularMovies(page: request.page) { resultMov in
            switch resultMov {
            case .error(let errorMov):
                self.presenter?.showError(withMessage: errorMov.localizedDescription)
            case .success(let responseMov):
                let response = MoviesList.FetchMovies.ResponseMovies(movies: responseMov.movies, total: responseMov.totalResults)
                self.presenter?.showMoviesList(response: response)
            }
        }
    }
    
}
