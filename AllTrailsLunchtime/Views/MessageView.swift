//
//  RestaurantRow.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/27/21.
//
// For now this is strictly used for errors.

import SwiftUI
import SDWebImageSwiftUI

struct MessageView: View {
    var message = ""

    var body: some View {
        HStack (alignment: .top) {
            Image("error").foregroundColor(Color.red)
                .frame(width: 32, height: 32, alignment: .center)
                .padding(.leading, kHalfPadding)
            Text(message)
                .fixedSize(horizontal: false, vertical: true)
        }.padding(kHalfPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        .overlay(RoundedRectangle(cornerRadius: kCornerRadius / 2).stroke(Color(UIColor.systemGray4), lineWidth: kBorderLineWidth))
        .padding(kDefaultPadding) // Yes, another padding.  This will keep the borderline away from the edges.  The first one is to keep contents of row away from the border.
    }
}
