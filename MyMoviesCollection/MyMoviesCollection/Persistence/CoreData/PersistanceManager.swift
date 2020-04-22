//
//  PersistanceManager.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 15/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import CoreData

class PersistanceManager {
    
    static var shared = PersistanceManager()
    let managedObjectContext = PersistanceService.context
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteMovie")
    
    public func fetchFavoritesList(_ completion: @escaping (Result<[FavoriteMovie], ResponseError>) -> Void) {
        var favMovies: [FavoriteMovie] = []
        do {
            favMovies =  try managedObjectContext.fetch(fetchRequest) as? [FavoriteMovie] ?? []
            completion(Result.success(favMovies))
        } catch {
            completion(Result.failure(ResponseError.generic))
        }
    }
    
    public func saveFavorite(movie: Movie) -> Bool {
        let movieToSave = FavoriteMovie(context: managedObjectContext)
        movieToSave.title = movie.title
        movieToSave.id = movie.id ?? 0
        movieToSave.overview = movie.overview
        movieToSave.year = String(movie.releaseDate?.prefix(4) ?? "0000")
        movieToSave.posterUrl = movie.posterUrl
        do {
           try managedObjectContext.save()
            return true
        } catch {
            return false
        }
        
    }
    
    public func deleteFavorite(id: Int32) -> Bool {
        var didDeleted = false
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        do {
            if let items = try managedObjectContext.fetch(fetchRequest) as? [FavoriteMovie] {
                for item in items {
                    managedObjectContext.delete(item)
                    didDeleted = true
                }
                try managedObjectContext.save()
                return didDeleted
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    public func checkFavorite(id: Int32) -> Bool {
        let predicate = NSPredicate(format: "id == %d", id)
        fetchRequest.predicate = predicate
        do {
            let result = try managedObjectContext.fetch(fetchRequest) as? [FavoriteMovie] ?? []
            return result.count > 0 ? true : false
        } catch {
            return false
        }
    }
}
