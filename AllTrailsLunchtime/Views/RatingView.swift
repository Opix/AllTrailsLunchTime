//
//  RatingView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 9/2/21.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Double
    
    var body: some View {
        ForEach (1...5, id: \.self) { i in
            Image("star")
                .frame(width: 16, height: 16, alignment: .center)
                .foregroundColor(i <= Int(rating) ? rateColor : Color(UIColor.systemGray5))
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(1.3))
    }
}
