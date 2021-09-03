//
//  AllRatesResponse.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/29/21.
//

import Foundation

public struct AllResponse: Decodable {
    let results: [ApiRestaurant]?
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.results = try values.decode([ApiRestaurant].self, forKey: .results)
    }
}
