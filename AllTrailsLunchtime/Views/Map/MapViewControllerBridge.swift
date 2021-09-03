//
//  MapViewControllerBridge.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//
// References:
// https://developers.google.com/codelabs/maps-platform/maps-platform-ios-swiftui#7

import GoogleMaps
import SwiftUI

struct MapViewControllerBridge: UIViewControllerRepresentable {
    @Binding var restaurants: [RestaurantModel]
    @Binding var selectedRestaurant: RestaurantModel?
    @Binding var filterOption: FilterOptions
    var onMarkerTapped: (_ restaurant: RestaurantModel) -> Void
    
    final class MapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapViewControllerBridge: MapViewControllerBridge

        init(_ mapViewControllerBridge: MapViewControllerBridge) {
            self.mapViewControllerBridge = mapViewControllerBridge
        }
        
        func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
            mapViewControllerBridge.markerTapped(marker: marker)
            return true
        }
    }
    
    private func markerTapped(marker: GMSMarker) {
        if let selected = restaurants.first(where: { $0.latitude == marker.position.latitude && $0.longitude == marker.position.longitude }) {
            onMarkerTapped(selected)
        }
    }
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator(self)
    }
    
    func makeUIViewController(context: Context) -> MapViewController {
        let viewController = MapViewController()
        viewController.map.delegate = context.coordinator
        viewController.map.setMinZoom(10, maxZoom: 20)

        return viewController
    }

    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
        // Although the map is getting new records as filter is changed, this is still needed.
        uiViewController.map.clear()
        var selectedMarker: GMSMarker? = nil
        let filteredList = filtered()
        
        let markers = filteredList.map { (restaurant: RestaurantModel) -> GMSMarker in
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude))

            marker.icon = GMSMarker.markerImage(with: restaurant.isFavorite ? UIColor(appPrimaryColor) : UIColor(appDarkGray))
            marker.map = uiViewController.map
            
            if selectedMarker == nil {
                if (self.selectedRestaurant?.id ?? "") == restaurant.id {
                    selectedMarker = marker
                }
            }
            return marker
        }

        guard markers.count > 0 else {
            return
        }
        animateToSelectedMarker(viewController: uiViewController, selectedMarker: selectedMarker ?? markers[0])
    }

    private func animateToSelectedMarker(viewController: MapViewController, selectedMarker: GMSMarker) {
        let map = viewController.map
        if map.selectedMarker != selectedMarker {
            map.selectedMarker = selectedMarker
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                map.animate(with: GMSCameraUpdate.setTarget(selectedMarker.position))
                
                if map.camera.zoom < 15 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        map.animate(toZoom: 15)
                    })
                }
            }
        }
    }
    
    func filtered() -> [RestaurantModel] {
        if filterOption == .favoritesOnly {
            return restaurants.filter { $0.isFavorite == true }
        }
        return restaurants
    }
}
