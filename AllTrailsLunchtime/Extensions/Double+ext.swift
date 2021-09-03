//
//  Double+ext.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/31/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import Foundation

extension Double {
    var formatTo1Fraction: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1

        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }

}
