//
//  SortOptions.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 9/1/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

enum FilterOptions: Int, CaseIterable, Identifiable {
    var id: Int { self.rawValue }
    
    case favoritesOnly
    case all

    var title: String {
        switch self {
            case .favoritesOnly:
                return "Show Favorites Only"
            case .all:
                return "Show All"
        }
    }
}
