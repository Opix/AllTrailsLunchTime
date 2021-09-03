//
//  RestaurantModel.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit
import GoogleMaps

class Restaurants: ObservableObject {
    @Published var list: [RestaurantModel]

    init(){
        self.list = [RestaurantModel]()
    }
}
