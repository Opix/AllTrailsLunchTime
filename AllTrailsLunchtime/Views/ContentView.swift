//
//  ContentView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//
// References:
// https://github.com/exyte/PopupView

import SwiftUI
import CoreData
import ExytePopupView

struct ContentView: View {
    private let searchCoordinator = SearchCoordinator()
    @StateObject private var locationViewModel = LocationViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var currentSearch = ""
    @State private var searchText = ""
    @State private var isList = false
    
    @State private var isDownloading = false
    @State private var showPopup = false
    @State private var showDetails = false
    @State private var currentSort: SortOptions = .ratingHighToLow
    @State private var currentFilter: FilterOptions = .all
    @State private var errorMessage: String? = nil

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Restaurant.id, ascending: true)], animation: .default)
    private var favorites: FetchedResults<Restaurant>
    
    @ObservedObject private var restaurants = Restaurants()
    @State var selectedRestaurant: RestaurantModel? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    ActionView(sortEnabled: .constant(isList && restaurants.list.count > 0),
                               currentSort: $currentSort,
                               filterEnabled: .constant(restaurants.list.count > 0),
                               currentFilter: $currentFilter,
                               searchText: $searchText,
                               searchTapped: {
                        // Already searched by this keyword?  If so, ignore.
                        if self.currentSearch == searchText {
                            return
                        }
                        currentSearch = searchText
                        self.hideKeyboard()
                        
                        isDownloading = true
                        searchCoordinator.downloadBy(keyword: searchText, completion: { (source, errorMessage) in
                            isDownloading = false
                            
                            DispatchQueue.main.async {
                                guard errorMessage == nil,
                                      let newRestaurants = source else {
                                        restaurants.list.removeAll()
                                    return
                                }
                                updateRestaurantList(newRestaurants)
                                doSort(by: currentSort)
                                self.selectedRestaurant = nil
                            }
                        })
                    }, sort: { (option) in
                        currentSort = option
                        doSort(by: option)
                    }, filter: { (option) in
                        if currentFilter != option {
                            currentFilter = option
                        }
                    })
                    .padding(.top, kDefaultPadding)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("logo").padding(.top, kDefaultPadding)
                        }
                    }.configureNavigationBar {
                        // Clear background color.  Plus the border at the bottom of navigation.
                        $0.navigationBar.setBackgroundImage(UIImage(), for: .default)
                        $0.navigationBar.shadowImage = UIImage()
                    }
                    
                    if isList {
                        RestaurantListView(restaurants: $restaurants.list, selectedRestaurant: $selectedRestaurant, favorites: favorites, isFavoriteOnly: currentFilter == .favoritesOnly)
                            .onTapGesture {
                                self.hideKeyboard()
                            }.environment(\.managedObjectContext, viewContext)
                    } else {
                        if locationViewModel.currentLatitude == nil || locationViewModel.currentLongitude == nil {
                            MyProgressView()
                        } else {
                            // ZStack to show a selected restaurant in the popup.
                            ZStack {
                                MapViewControllerBridge(restaurants: $restaurants.list,
                                                        selectedRestaurant: $selectedRestaurant,
                                                        filterOption: $currentFilter,
                                    onMarkerTapped: { (restaurant) in
                                        selectedRestaurant = restaurant
                                        showPopup = true
                                        self.hideKeyboard()
                                })
                                .onTapGesture {
                                    self.hideKeyboard()
                                }.onAppear {
                                    // Use coordinates for searching when seach keyword is empty.
                                    guard currentSearch.isEmpty,
                                          let latitude = locationViewModel.currentLatitude,
                                          let longitude = locationViewModel.currentLongitude else {
                                        return
                                    }
                                    isDownloading = true
                                    
                                    searchCoordinator.downloadBy(latitude: latitude, longitude: longitude, completion: { (source, errorMessage) in
                                        isDownloading = false
                                        
                                        DispatchQueue.main.async {
                                            guard errorMessage == nil,
                                                  let newRestaurants = source else {
                                                    restaurants.list.removeAll()
                                                self.errorMessage = errorMessage
                                                return
                                            }

                                            updateRestaurantList(newRestaurants)
                                            doSort(by: currentSort)
                                        }
                                    })
                                }
                            // A restaurant is tapped in the map view.  Show it as a popup
                            }.if(self.selectedRestaurant != nil) {
                                // position means where this popup is coming from, top or bottom.
                                $0.popup(isPresented: $showPopup, position: .top) {
                                    RestaurantRow(restaurant: .constant(self.selectedRestaurant!), onFavoriteTapped: {
                                    }, showFavorite: false)
                                }
                            // This is used when getting data fails.
                            }.if(self.errorMessage != nil) {
                                $0.popup(isPresented: .constant(self.errorMessage != nil), position: .top, autohideIn: 3, dismissCallback: {
                                    self.errorMessage = nil
                                }) {
                                    MessageView(message: self.errorMessage!)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                }.navigationBarTitle(Text(""), displayMode: .inline)

                if isDownloading {
                    MyProgressView()
                }
                
                // Floating button to switch views.
                SwitchView(isList: $isList, onSwitchTapped: {
                    self.isList.toggle()
                    
                    // When switched to List, the details page is automatically triggered when something is selected.
                    // I don't want that so clear selection.
                    if isList {
                        selectedRestaurant = nil
                    }
                })
            // Location Service can not be accessed.  Terminate this app in 10 seconds.
            }.popup(isPresented: .constant(self.locationViewModel.authorizationStatus == .denied || self.locationViewModel.authorizationStatus == .restricted), position: .top, autohideIn: 10, dismissCallback: {
                    exit(-1)
                }) {
                    MessageView(message: "Please allow this app to access Location Services; otherwise, this app will not work.  Please reset in settings.  This app will be closed shortly...")
                        .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
    
    private func updateRestaurantList(_ list: [RestaurantModel]) {
        restaurants.list = list.map { (restaurant: RestaurantModel) -> RestaurantModel in
            var tempo = restaurant
            tempo.isFavorite = favorites.first(where: { $0.id == restaurant.id }) != nil
            return tempo
        }
    }
    
    private func doSort(by option: SortOptions) {
        switch option {
            case .ratingLowToHigh:
                restaurants.list.sort(by: { $0.rating < $1.rating })
            case .ratingHighToLow:
                restaurants.list.sort(by: { $0.rating > $1.rating })
            case .priceLowToHigh:
                restaurants.list.sort(by: { $0.priceLevel < $1.priceLevel })
            case .priceHighToLow:
                restaurants.list.sort(by: { $0.priceLevel > $1.priceLevel })
            case .nameAToZ:
                restaurants.list.sort(by: { $0.name < $1.name })
            case .nameZtoA:
                restaurants.list.sort(by: { $0.name > $1.name })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
