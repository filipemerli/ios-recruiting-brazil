//
//  FavoritesPresenter.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 18/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol FavoritesPresentationLogic {
    func showFavorites(response: Favorites.Fetch.Response)
    func showFavoriteBanner(response: Favorites.MovieInfo.ResponseBanner)
    func deleteFavorite(response: Favorites.DeleteFavorite.Response)
    func showError(withMessage message: String)
}

class FavoritesPresenter: FavoritesPresentationLogic {
    
    weak var viewController: (FavoritesViewController)?
    
    func showFavorites(response: Favorites.Fetch.Response) {
        let viewModel = Favorites.Fetch.ViewModel(movies: response.movies)
        viewController?.renderFavorites(viewModel: viewModel)
    }
    
    func showFavoriteBanner(response: Favorites.MovieInfo.ResponseBanner) {
        let viewModel = Favorites.MovieInfo.ViewModelBanner(cell: response.cell, image: response.image)
        viewController?.renderFavoritesBanner(viewModel: viewModel)
    }
    
    func showError(withMessage message: String) {
        //viewController?.showEmptyStateIfNeeded()  **** TO DO
        viewController?.showErrorAlert(with: message)
    }
    
    func deleteFavorite(response: Favorites.DeleteFavorite.Response) {
        let viewModel = Favorites.DeleteFavorite.ViewModel(movieToDelete: response.success, indexToDelete: response.indexPath ?? [])
        viewController?.deleteFavorite(viewModel: viewModel)
    }
    
}
