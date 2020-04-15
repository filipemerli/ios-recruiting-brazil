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
}

protocol MovieDetailDataStore {
    var movie: Movie? { get set }
}

class MovieDetailInteractor: MovieDetailBusinessLogic, MovieDetailDataStore {
    
    var movie: Movie?
    var presenter: MovieDetailPresentationLogic?
    private var worker: MovieDetailWorker?
    private var genres: [Genre] = []
    
    init (worker: MovieDetailWorker = MovieDetailWorker()) {
        self.worker = worker
    }
    
    // MARK: - Get movie genres
    
    func fetchMovieGenres() {
        worker?.fetchGenres() { resultGens in
            switch resultGens {
            case .error(let errorGens):
                self.presenter?.showError(withMessage: errorGens.localizedDescription)
            case .success(let responseGens):
                self.genres.append(contentsOf: responseGens.genres)
                let response = MovieDetail.ShowMovieDetail.MovieGenres(genres: self.findGens(genIds: self.movie?.generedIds ?? [0]))
                self.presenter?.showMovieGenres(viewModel: response)
            }
        }
    }
    
    private func findGens(genIds: [Int?]) -> String {
        var finalGenString = ""
        for i in 0..<genIds.count {
            finalGenString.append(contentsOf: getGenById(from: genIds[i] ?? 0))
            if i != (genIds.count - 1) {
                finalGenString.append(contentsOf: ", ")
            }
        }
        return finalGenString
    }
    
    private func getGenById(from id: Int) -> String {
        for index in 0..<genres.count  {
            if genres[index].id == id {
                return genres[index].name
            }
        }
        return ""
    }
    
    // MARK: - Show Movie Details
    
    func fetchMovieDetails() {
        guard let showMovie = movie else { return }
        self.presenter?.showMovieDetail(viewModel: MovieDetail.ShowMovieDetail.ViewModel(movie: showMovie))
    }
    
    // MARK: - Fetch Banner Image
    
    func fetchBannerImage() {
        guard let bannerUrl = movie?.posterUrl else { return }
        worker?.fetchBanner(posterUrl: bannerUrl, { resultBanner in
            switch resultBanner {
            case .error(let errorBanner):
                self.presenter?.showError(withMessage: errorBanner.localizedDescription)
            case .success(let responseBanner):
                self.presenter?.showMovieBanner(viewModel: MovieDetail.ShowMovieDetail.MovieBanner(movieBanner: responseBanner))
            }
        })
    }
    
}
