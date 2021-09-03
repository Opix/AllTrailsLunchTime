//
//  RestaurantModel.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

public struct RestaurantModel: Identifiable {
    public var id: String
    var name: String
    var rating: Double = 1.0 // 1 - 5
    var totalReviews: Int = 0
    var priceLevel: Int = 1 // $ - $$$
    var description: String? = nil
    var iconUrl: String? = nil
    var latitude: Double = 0
    var longitude: Double  = 0
    var isFavorite = false // green if true
    var address: String? = nil
    var photoReference: String? = nil
    
    init(_ id: String, name: String, rating: Double = 1.0, totalReviews: Int = 0, priceLevel: Int = 1, description: String? = nil, iconUrl: String? = nil, latitude: Double = 0.0, longitude: Double = 0.0, address: String? = nil, photoReference: String? = nil) {
        self.id = id
        self.name = name
        self.rating = rating
        self.totalReviews = totalReviews
        self.priceLevel = priceLevel
        self.description = description
        self.iconUrl = iconUrl
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.photoReference = photoReference
    }
}

extension RestaurantModel {    
    var favoriteImage: some View {
        if isFavorite {
            return Image("favorite").foregroundColor(appPrimaryColor)
        } else {
            return Image("non_favorite").foregroundColor(Color(UIColor.systemGray4))
        }
    }
    
    var priceRangeAndDescription: String {
        let level = priceRangeAsDollarSigns
        
        guard let description = description,
              !description.isEmpty else {
            return level
        }
        
        return "\(level) • \(description)"
    }
    
    var priceRangeAsDollarSigns: String {
        var level = "$" // At least one $.

        for _ in 1..<priceLevel {
            level = "\(level)$"
        }
        
        return level
    }
    
    var descriptionOrNA: String {
        return description ?? "N/A"
    }
}
