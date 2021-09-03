//
//  SortOptions.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 9/1/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

enum SortOptions: Int, CaseIterable, Identifiable {
    var id: Int { self.rawValue }
    
    case nameAToZ
    case nameZtoA
    case priceLowToHigh
    case priceHighToLow
    case ratingLowToHigh
    case ratingHighToLow

    var title: String {
        switch self {
            case .nameAToZ:
                return "Name A to Z"
            case .nameZtoA:
                return "Name Z to A"
            case .priceLowToHigh:
                return "Price $ to $$$"
            case .priceHighToLow:
                return "Price $$$ to $"
            case .ratingLowToHigh:
                return "Rating Low to High"
            case .ratingHighToLow:
                return "Rating Hight to Low"
        }
    }
}
