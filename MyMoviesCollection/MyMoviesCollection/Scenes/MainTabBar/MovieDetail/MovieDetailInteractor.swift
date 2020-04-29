//
//  MovieDetailInteractor.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 06/04/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

protocol MovieDetailBusinessLogic {
    func fetchMovieGenres()
    func fetchMovieDetails()
    func fetchBannerImage()
    func favoriteMovie()
}

protocol MovieDetailDataStore {
    var movie: Movie? { get set }
}

final class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    
    var movie: Movie?
    var presenter: MovieDetailPresentationLogic?
    private var worker: MovieDetailWorker?
    var dataManager: PersistanceManager?
    private var genres: [Genre] = []
    
    init (worker: MovieDetailWorker = MovieDetailWorker()) {
        self.worker = worker
    }
    
    // MARK:  Fetch movies genres from API    **** TO DO: Save this on Core Data???
    
    func fetchMovieGenres() {
        worker?.fetchGenres() { resultGens in
            switch resultGens {
            case .failure(let errorGens):
                self.presenter?.showError(withMessage: errorGens.reason)
            case .success(let responseGens):
                self.genres.append(contentsOf: responseGens.genres)
                let response = MovieDetail.ShowMovieDetail.MovieGenres(genres: self.findGens(genIds: self.movie?.generedIds ?? [0]))
                self.presenter?.showMovieGenres(response: response)
            }
        }
    }
    
    fileprivate func findGens(genIds: [Int?]) -> String {
        var finalGenString = ""
        for i in 0..<genIds.count {
            finalGenString.append(contentsOf: getGenById(from: genIds[i] ?? 0))
            if i != (genIds.count - 1) {
                finalGenString.append(contentsOf: ", ")
            }
        }
        return finalGenString
    }
    
    fileprivate func getGenById(from id: Int) -> String {
        for index in 0..<genres.count  {
            if genres[index].id == id {
                return genres[index].name
            }
        }
        return ""
    }
    
    // MARK: Check if movie is favorite and present the movie
    
    func fetchMovieDetails() {
        guard let showMovie = movie else {
            presenter?.showError(withMessage: "Filme vazio.")
            return
        }
        self.presenter?.showMovieDetail(response: MovieDetail.ShowMovieDetail.ViewModel(movie: showMovie))
        guard let movieId = movie?.id else {
            presenter?.showError(withMessage: "Não foi possível verificar se o filme é favorito.")
            return
        }
        let isFav = dataManager?.checkFavorite(id: movieId) ?? false
        self.presenter?.showFavoriteFeedback(response: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback(favButtonFeedback: isFav))
        
    }
    
    // MARK: Load image from API
    
    func fetchBannerImage() {
        guard let bannerUrl = movie?.posterUrl else {
            presenter?.showError(withMessage: "Não foi possível obter a imagem do poster deste filme.")
            return
        }
        worker?.loadImage(posterUrl: bannerUrl, { resultBanner in
            switch resultBanner {
            case .failure( _):
                let response = MovieDetail.ShowMovieDetail.MovieBanner(image: nil)
                self.presenter?.showMovieBanner(response: response)
            case .success(let image):
                self.presenter?.showMovieBanner(response: MovieDetail.ShowMovieDetail.MovieBanner(image: image))
            }
        })
    }
    
    // MARK: Save movie as favorite
    
    func favoriteMovie() {
        guard let movieToSave = movie else {
            self.presenter?.showError(withMessage: "Filme vazio.")
            return
        }
        let favorited = dataManager?.saveFavorite(movie: movieToSave) ?? false
        if favorited {
            self.presenter?.showFavoriteFeedback(response: MovieDetail.ShowMovieDetail.MovieFavButtonFeedback(favButtonFeedback: true))
        } else {
            self.presenter?.showError(withMessage: "Erro ao favoritar, tente novamente.")
        }
    }
    
}
