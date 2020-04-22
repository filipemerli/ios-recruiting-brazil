//
//  SearchMovieInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 22/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol SearchMovieBusinessLogic {
    func fetchSearchMovies()
    func fetchBannerImage(request: SearchMovie.MovieInfo.RequestBanner)
    func checkIfFavorite(request: SearchMovie.MovieInfo.RequestFavorite)
}

protocol SearchMovieDataStore {
    var keyWord: String? { get set }
}

class SearchMovieInteractor: SearchMovieBusinessLogic, SearchMovieDataStore {
    
    var keyWord: String?
    var presenter: SearchMoviePresentationLogic?
    private var worker: SearchMovieWorker?
    
    init (worker: SearchMovieWorker = SearchMovieWorker()) {
        self.worker = worker
    }
    
    // MARK: Fetch movies from API
    
    func fetchSearchMovies() {
        guard let searchKey = keyWord else {
            presenter?.showError(withMessage: "Busca inválida.")
            return
        }
        worker?.fetchSearchMovies(keyWord: searchKey) { resultMov in
            switch resultMov {
            case .failure(let errorMov):
                self.presenter?.showError(withMessage: errorMov.reason)
            case .success(let responseMov):
                let response = SearchMovie.Fetch.Response(movies: responseMov.movies)
                self.presenter?.showMoviesList(response: response)
            }
        }
    }
    
    // MARK: Load Image from API
        
    func fetchBannerImage(request: SearchMovie.MovieInfo.RequestBanner) {
        worker?.loadImage(posterUrl: request.posterUrl, { result in
            switch result {
            case .failure(let error):
                debugPrint("FetchBanner error: \(error.reason)")
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
        worker?.checkIfFavorite(movieId: request.movieId, { success in
            let response = SearchMovie.MovieInfo.ResponseFavorite(cell: request.cell, isFavorite: success)
            self.presenter?.showFavoriteFeedback(response: response)
        })
        
    }
    
}
