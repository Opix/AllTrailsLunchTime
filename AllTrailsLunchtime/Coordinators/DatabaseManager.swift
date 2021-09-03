//
//  SearchCoordinator.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//

import UIKit
import Foundation
import CoreData
import SwiftUI

class DatabaseManager: NSObject {
    let persistenceController = PersistenceController.shared
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Restaurant.id, ascending: true)], animation: .default)
    var favorites: FetchedResults<Restaurant>
    
    override init() {
        super.init()
    }
    
    var viewContext: NSManagedObjectContext {
        return persistenceController.container.viewContext
    }
    
    func isFavroite(restaurantId: String) -> Bool {
        return favorites.first(where: { $0.id == restaurantId }) != nil
    }
    
    func addFavorite(_ restaurant: RestaurantModel) {
        withAnimation {
            do {
                if let _ = favorites.first(where: { $0.id == restaurant.id }) {
                    return
                }
                
                let newFavorite = Restaurant(context: viewContext)
                newFavorite.id = restaurant.id

                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func deleteFavorite(_ restaurant: RestaurantModel) {
        withAnimation {
            guard let delete = favorites.first(where: { $0.id == restaurant.id }) else {
                return
            }
            
            do {
                viewContext.delete(delete)
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
