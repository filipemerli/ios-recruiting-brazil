//
//  PersistanceService.swift
//  MyMoviesCollection
//
//  Created by Filipe Merli on 15/03/20.
//  Copyright © 2020 Filipe Merli. All rights reserved.
//

import Foundation
import CoreData

final class PersistanceService {
    
    static var context: NSManagedObjectContext {
      return persistentContainer.viewContext
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "FavoriteMovieCoreData")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static func saveContext () -> Bool {
      let context = persistentContainer.viewContext
      if context.hasChanges {
        do {
          try context.save()
            return true
        } catch {
            return false
        }
      } else {
        return false
        }
    }
    
    deinit {
        do {
            try PersistanceService.context.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
}
