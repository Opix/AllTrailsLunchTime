//
//  ApiRestaurant.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

public struct ApiRestaurant: Codable {
    var id: String
    var name: String
    var rating: Double? = nil // 1 - 5
    var totalReviews: Int = 0
    var priceLevel: Int? = nil // $ - $$$
    var types: [String]? = nil // restaurants, food, etc.
    var iconUrl: String? = nil
    var geometry: ApiGeometry? = nil
    var address: String? = nil
    var photos: [ApiPhotos]? = nil
    
    init(_ id: String, name: String, rating: Double = 1.0, totalReviews: Int = 0, priceLevel: Int = 1, types: [String]? = nil, iconUrl: String? = nil, geometry: ApiGeometry? = nil, address: String? = nil, photos: [ApiPhotos]? = nil) {
        self.id = id
        self.name = name
        self.rating = rating
        self.totalReviews = totalReviews
        self.priceLevel = priceLevel
        self.types = types
        self.iconUrl = iconUrl
        self.geometry = geometry
        self.address = address
        self.photos = photos
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "place_id"
        case name = "name"
        case rating = "rating"
        case totalReviews = "user_ratings_total"
        case priceLevel = "price_level"
        case iconUrl = "icon"
        case geometry = "geometry"
        case types = "types"
        case address = "formatted_address"
        case photos = "photos"
    }
}

extension ApiRestaurant {
    func toModel() -> RestaurantModel {
        var descriptions: String? = nil
        
        if let tempo = types {
            descriptions = tempo.map { $0.replacingOccurrences(of: "_", with: " ") }.joined(separator: ", ")
        }
        
        return RestaurantModel(id,
                               name: name,
                               rating: rating ?? 1,
                               totalReviews: totalReviews,
                               priceLevel: priceLevel ?? 1,
                               description: descriptions,
                               iconUrl: iconUrl,
                               latitude: geometry?.latitude ?? 0,
                               longitude: geometry?.longitude ?? 0,
                               address: address,
                               photoReference: photos?[0].photoReference) // just one for now.
    }
}
