//
//  MoviesAPIClient.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 13/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

public enum MoviesApiClientResponse<T> {
    case success(T)
    case error(Error)
}

class MoviesAPIClient: ApiClient {
    
    static var shared: MoviesAPIClient = {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "Content-Type" : "application/json",
            "Accept" : "application/json"
        ]
        config.requestCachePolicy = .useProtocolCachePolicy
        return MoviesAPIClient(configuration: config)
    }()
    
    let defaultParameters = ["api_key" : "6009379178c6cf65ffc7468b6598440f", "language" : "pt-BR"]
    
    func fetchPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ResponseError>) -> Void) {
        let url = Endpoints<MoviesAPIClient>.popularMovies.url
        let parameters = ["page": "\(page)"].merging(defaultParameters, uniquingKeysWith: +)
        let request = buildRequest(.get, url: url, parameters: parameters)
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchMoviesGenres(completion: @escaping (Result<GenresResponse, ResponseError>) -> Void) {
        let url = Endpoints<MoviesAPIClient>.genders.url
        let request = buildRequest(.get, url: url, parameters: defaultParameters)
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(GenresResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchSearchMovie(text: String, completion: @escaping (Result<MoviesResponse, ResponseError>) -> Void) {
        let url = Endpoints<MoviesAPIClient>.searchMovies.url
        let parameters = ["query": text].merging(defaultParameters, uniquingKeysWith: +)
        let request = buildRequest(.get, url: url, parameters: parameters)
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(Result.failure(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                completion(Result.failure(ResponseError.decoding))
                return
            }
            completion(Result.success(decodedResponse))
        }).resume()
    }
    
    func fetchMovies(page: Int, _ completion: @escaping (MoviesApiClientResponse<MoviesResponse>) -> Void) {
        let url = Endpoints<MoviesAPIClient>.popularMovies.url
        let parameters = ["page": "\(page)"].merging(defaultParameters, uniquingKeysWith: +)
        let request = buildRequest(.get, url: url, parameters: parameters)
        session.dataTask(with: request, completionHandler: { data, response, error in
            guard
                let httpResponse = response as? HTTPURLResponse, httpResponse.hasSuccessStatusCode,
                let data = data
                else {
                    completion(MoviesApiClientResponse.error(ResponseError.rede))
                    return
            }
            guard let decodedResponse = try? JSONDecoder().decode(MoviesResponse.self, from: data) else {
                completion(MoviesApiClientResponse.error(ResponseError.decoding))
                return
            }
            completion(MoviesApiClientResponse.success(decodedResponse))
        }).resume()
    }
    
    override class var baseURL: String {
        return "https://api.themoviedb.org/3/"
    }
    
}
