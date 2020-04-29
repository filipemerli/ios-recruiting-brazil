//
//  SearchMovieInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol SearchMovieBusinessLogic {
    func fetchSearchMovies(request: SearchMovie.Fetch.Request)
    func fetchBannerImage(request: SearchMovie.MovieInfo.RequestBanner)
    func checkIfFavorite(request: SearchMovie.MovieInfo.RequestFavorite)
}

protocol SearchMovieDataStore {
    var keyWord: String? { get set }
}

final class SearchMovieInteractor: SearchMovieBusinessLogic, SearchMovieDataStore {
    
    var keyWord: String?
    var presenter: SearchMoviePresentationLogic?
    private var worker: SearchMovieWorker?
    var dataManager: PersistanceManager?
    
    init (worker: SearchMovieWorker = SearchMovieWorker()) {
        self.worker = worker
    }
    
    // MARK: Fetch movies from API
    
    func fetchSearchMovies(request: SearchMovie.Fetch.Request) {
        guard let searchKey = keyWord else {
            presenter?.showError(withMessage: "Busca inválida.")
            return
        }
        worker?.fetchSearchMovies(page: request.page, keyWord: searchKey) { resultMov in
            switch resultMov {
            case .failure(let errorMov):
                self.presenter?.showError(withMessage: errorMov.reason)
            case .success(let responseMov):
                let response = SearchMovie.Fetch.Response(movies: responseMov.movies, keyWord: searchKey, totalResults: responseMov.totalResults)
                self.presenter?.showMoviesList(response: response)
            }
        }
    }
    
    // MARK: Load Image from API
        
    func fetchBannerImage(request: SearchMovie.MovieInfo.RequestBanner) {
        worker?.loadImage(posterUrl: request.posterUrl, { result in
            switch result {
            case .failure( _):
                let response = SearchMovie.MovieInfo.ResponseBanner(cell: request.cell, image: nil)
                self.presenter?.showMovieBanner(response: response)
            case .success(let image):
                let response = SearchMovie.MovieInfo.ResponseBanner(cell: request.cell, image: image)
                self.presenter?.showMovieBanner(response: response)
            }
        })
    }
    
    // MARK: Check if is favorite
    
    func checkIfFavorite(request: SearchMovie.MovieInfo.RequestFavorite) {
        let success = dataManager?.checkFavorite(id: request.movieId) ?? false
        let response = SearchMovie.MovieInfo.ResponseFavorite(cell: request.cell, isFavorite: success)
        self.presenter?.showFavoriteFeedback(response: response)
    }
    
}
