//
//  Movie.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 13/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation

struct Movie: Decodable {
    let title: String?
    let id: Int32?
    let posterUrl: String?
    let overview: String?
    let releaseDate: String?
    let generedIds: [Int?]
    let isFavorite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case title = "original_title"
        case id
        case posterUrl = "poster_path"
        case overview
        case releaseDate = "release_date"
        case generedIds = "genre_ids"
        case isFavorite
    }
    
    init(title: String, id: Int32, posterUrl: String, overview: String, releaseDate: String, generedIds: [Int], isFavorite: Bool) {
        self.title = title
        self.id = id
        self.posterUrl = posterUrl
        self.overview = overview
        self.releaseDate = String(releaseDate.prefix(4))
        self.generedIds = generedIds
        self.isFavorite = false
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let title = (try? container.decode(String.self, forKey: .title)) ?? ""
        let id = (try? container.decode(Int32.self, forKey: .id)) ?? 0
        let posterUrl = (try? container.decode(String.self, forKey: .posterUrl)) ?? ""
        let overview = (try? container.decode(String.self, forKey: .overview)) ?? ""
        let releaseDate = (try? container.decode(String.self, forKey: .releaseDate)) ?? ""
        let generedIds = (try? container.decode([Int].self, forKey: .generedIds)) ?? []
        let isFavorite = false
        self.init(title: title, id: id, posterUrl: posterUrl, overview: overview, releaseDate: releaseDate, generedIds: generedIds, isFavorite: isFavorite)
    }
    
}
