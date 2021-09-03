//
//  RestaurantListView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/28/21.
//
// References:
// https://stackoverflow.com/questions/61495141/passing-core-data-fetchedresultst-for-previews-in-swiftui

import SwiftUI

struct RestaurantListView<Results:RandomAccessCollection>: View where Results.Element == Restaurant {
    @Binding var restaurants: [RestaurantModel]
    @Binding var selectedRestaurant: RestaurantModel?
    @Environment(\.managedObjectContext) private var viewContext
    var favorites: Results
    var isFavoriteOnly = false
    
    var body: some View {
        GeometryReader { geo in
            if restaurants.count > 0 {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(restaurants.indices) { i in
                            if !isFavoriteOnly || (isFavoriteOnly && self.restaurants[i].isFavorite) {
                                RestaurantRow(restaurant: self.$restaurants[i], onFavoriteTapped: {
                                    if self.restaurants[i].isFavorite {
                                        addFavorite(self.restaurants[i])
                                    } else {
                                        deleteFavorite(self.restaurants[i])
                                    }
                                }, showFavorite: true, isSelected: self.restaurants[i].id == selectedRestaurant?.id)
                                .frame(width: geo.size.width, alignment: .leading)
                                .contentShape(Rectangle())
                                .simultaneousGesture(TapGesture().onEnded {
                                    selectedRestaurant = self.restaurants[i]
                                })
                            }
                        }
                    }
                    .padding(.top, kHalfPadding)
                    .padding(.bottom, 110) // <- so that the last row should be scrolled above the floating switch button
                    .frame(width: geo.size.width, alignment: .top)
                    .background(Color(UIColor.systemGray6))
                }
            } else {
                Text("No Results")
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .background(Color(UIColor.systemGray6))
                    .foregroundColor(Color(UIColor.systemGray2))
            }
        }
    }
    
    // Yes, these 2 functions should not be here.  Database transactions should be handled outside of View.
    // A class like DatabaseManager should take care of this.
    private func addFavorite(_ restaurant: RestaurantModel) {
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

    private func deleteFavorite(_ restaurant: RestaurantModel) {
        withAnimation {
            guard let delete = favorites.first(where: { $0.id == restaurant.id }) else {
                return
            }
            
            do {
                viewContext.delete(delete)
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
}
