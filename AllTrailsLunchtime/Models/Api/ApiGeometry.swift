//
//  ApiGeometry.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

public struct ApiGeometry: Codable {
    var location: ApiLocation?
    
    init(_ location: ApiLocation) {
        self.location = location
    }
    
    enum CodingKeys: String, CodingKey {
        case location = "location"
    }
}

extension ApiGeometry {
    var latitude: Double {
        return location?.latitude ?? 0.0
    }

    var longitude: Double {
        return location?.longitude ?? 0.0
    }
}
