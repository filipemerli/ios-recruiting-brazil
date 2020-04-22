//
//  MoviesListInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 24/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

protocol MoviesListBusinessLogic {
    func fetchPopularMovies(request: MoviesList.Fetch.Request)
    func fetchBannerImage(request: MoviesList.MovieInfo.RequestBanner)
    func checkIfFavorite(request: MoviesList.MovieInfo.RequestFavorite)
}

protocol MoviesListDataStore {
    //var movie: Movie { get set }  *** TO DO: Check this
}

class MoviesListInteractor: MoviesListBusinessLogic, MoviesListDataStore {

    var presenter: MoviesListPresentationLogic?
    private var worker: MoviesListFavoritesWorker?
    
    init (worker: MoviesListFavoritesWorker = MoviesListFavoritesWorker()) {
        self.worker = worker
    }
    
    // MARK: Fetch movies from API
    
    func fetchPopularMovies(request: MoviesList.Fetch.Request) {
        worker?.fetchPopularMovies(page: request.page) { resultMov in
            switch resultMov {
            case .error(let errorMov):
                self.presenter?.showError(withMessage: errorMov.localizedDescription)
            case .success(let responseMov):
                let response = MoviesList.Fetch.Response(movies: responseMov.movies, total: responseMov.totalResults)
                self.presenter?.showMoviesList(response: response)
            }
        }
    }
    
    // MARK: Load Image from API
        
    func fetchBannerImage(request: MoviesList.MovieInfo.RequestBanner) {
        worker?.loadImage(posterUrl: request.posterUrl, { result in
            switch result {
            case .error(let error):
                self.presenter?.showError(withMessage: error.localizedDescription)
            case .success(let image):
                let response = MoviesList.MovieInfo.ResponseBanner(cell: request.cell, image: image)
                self.presenter?.showMovieBanner(response: response)
            }
        })
    }
    
    // MARK: Check if is favorite
    
    func checkIfFavorite(request: MoviesList.MovieInfo.RequestFavorite) {
        worker?.checkIfFavorite(movieId: request.movieId, { success in
            let response = MoviesList.MovieInfo.ResponseFavorite(cell: request.cell, isFavorite: success)
            self.presenter?.showFavoriteFeedback(response: response)
        })
        
    }
    
}
