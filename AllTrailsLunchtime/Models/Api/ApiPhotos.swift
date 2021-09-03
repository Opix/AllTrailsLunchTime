//
//  ApiGeometry.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation
import SwiftUI

public struct ApiPhotos: Codable {
    var photoReference: String?
    // Don't care about everything else.
    
    enum CodingKeys: String, CodingKey {
        case photoReference = "photo_reference"
    }
}
