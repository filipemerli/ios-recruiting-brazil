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

final class MoviesListInteractor: MoviesListBusinessLogic, MoviesListDataStore {

    var presenter: MoviesListPresentationLogic?
    private var worker: MoviesListWorker?
    var dataManager: PersistanceManager?
    
    init (worker: MoviesListWorker = MoviesListWorker()) {
        self.worker = worker
    }
    
    // MARK: Fetch movies from API
    
    func fetchPopularMovies(request: MoviesList.Fetch.Request) {
        worker?.fetchPopularMovies(page: request.page) { resultMov in
            switch resultMov {
            case .failure(let errorMov):
                self.presenter?.showError(withMessage: errorMov.reason)
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
            case .failure( _):
                let response = MoviesList.MovieInfo.ResponseBanner(cell: request.cell, image: nil)
                self.presenter?.showMovieBanner(response: response)
            case .success(let image):
                let response = MoviesList.MovieInfo.ResponseBanner(cell: request.cell, image: image)
                self.presenter?.showMovieBanner(response: response)
            }
        })
    }
    
    // MARK: Check if is favorite
    
    func checkIfFavorite(request: MoviesList.MovieInfo.RequestFavorite) {
        let success = dataManager?.checkFavorite(id: request.movieId) ?? false
        let response = MoviesList.MovieInfo.ResponseFavorite(cell: request.cell, isFavorite: success)
        self.presenter?.showFavoriteFeedback(response: response)
    }
    
}
