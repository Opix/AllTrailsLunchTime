//
//  ApiLocation.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

public struct ApiLocation: Codable {
    var latitude: Double = 1.0
    var longitude: Double = 0
    
    init(lat: Double, lng: Double) {
        self.latitude = lat
        self.longitude = lng
    }
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
}
