//
//  FavoritesInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol FavoritesBusinessLogic {
    func fetchFavorites()
    func fetchBannerImage(request: Favorites.MovieInfo.RequestBanner)
    func deleteFavorite(request: Favorites.DeleteFavorite.Request)
}

protocol FavoritesDataStore {
    //var movie: Movie { get set }  *** TO DO: Check this
}

class FavoritesInteractor: FavoritesBusinessLogic, FavoritesDataStore {

    var presenter: FavoritesPresentationLogic?
    private var worker: FavoritesWorker?
    
    init (worker: FavoritesWorker = FavoritesWorker()) {
        self.worker = worker
    }
    
    // MARK: Fetch movies from API
    
    func fetchFavorites() {
        worker?.fetchFavorites({ result in
            switch result {
            case .failure(let error):
                self.presenter?.showError(withMessage: error.localizedDescription)
            case .success(let movies):
                let response = Favorites.Fetch.Response(movies: movies)
                self.presenter?.showFavorites(response: response)
            }
        })
    }
    
    // MARK: Load Image from API
        
    func fetchBannerImage(request: Favorites.MovieInfo.RequestBanner) {
        worker?.loadImage(posterUrl: request.posterUrl, { result in
            switch result {
            case .failure( _):
                let response = Favorites.MovieInfo.ResponseBanner(cell: request.cell, image: nil)
                self.presenter?.showFavoriteBanner(response: response)
            case .success(let image):
                let response = Favorites.MovieInfo.ResponseBanner(cell: request.cell, image: image)
                self.presenter?.showFavoriteBanner(response: response)
            }
        })
    }
    
    func deleteFavorite(request: Favorites.DeleteFavorite.Request) {
        worker?.deleteFavorite(movieId: request.movieId, { success in
            if success {
                let response = Favorites.DeleteFavorite.Response(success: success, indexPath: request.indexPath)
                self.presenter?.deleteFavorite(response: response)
            } else {
                self.presenter?.showError(withMessage: "Erro ao deletar favorito, tente novamente.")
            }
        })
    }
    
}
