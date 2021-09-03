//
//  RestaurantRow.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/27/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantRow: View {
    @Binding var restaurant: RestaurantModel
    var onFavoriteTapped: () -> Void
    var showFavorite = true
    var isSelected = false

    @State private var showDetails = false

    var body: some View {
        HStack (alignment: .center) {
            if let url = restaurant.iconUrl {
                WebImage(url: URL(string: url))
                    // Supports options and context, like `.delayPlaceholder` to show placeholder only when error
                    .onSuccess { image, data, cacheType in
                        // Success
                        // Note: Data exist only when queried from disk cache or network. Use `.queryMemoryData` if you really need data
                    }
                    .resizable() // Resizable like SwiftUI.Image, you must use this modifier or the view will use the image bitmap size
                    .placeholder(Image("restaurant")) // Placeholder Image
                    // Supports ViewBuilder as well
                    .placeholder {
                        Rectangle().foregroundColor(.gray)
                    }
                    .indicator(.activity) // Activity Indicator
                    .transition(.fade(duration: 0.5)) // Fade Transition with duration
                    .scaledToFit()
                    .frame(width: 60, height: 60, alignment: .center)
            } else {
                Image("restaurant")
                    .frame(width: 60, height: 60, alignment: .center)
                    .padding(.leading, kHalfPadding)
            }
            VStack (alignment: .leading, spacing: 2) {
                HStack (alignment: .center) {
                    Text(restaurant.name)
                        .font(.title3)
                        .bold()
                        .foregroundColor(appDarkGray)
                        .lineLimit(1)
                    
                    // In the Map view, favorite is hidden, according to the inVision image.
                    if showFavorite {
                        Spacer()

                        Button (action: {
                            restaurant.isFavorite.toggle()
                            self.onFavoriteTapped()
                            }) {
                            restaurant.favoriteImage
                        }.buttonStyle(PlainButtonStyle())
                    }
                }
                HStack (alignment: .center) {
                    Text(restaurant.rating.formatTo1Fraction)
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.systemGray2))
                        .padding(.trailing, 0)
                    
                    RatingView(rating: $restaurant.rating)
                    Text("(\(restaurant.totalReviews))")
                        .font(.footnote)
                        .foregroundColor(Color(UIColor.systemGray2))
                }.padding(.top, -2)
                
                HStack {
                    Text(restaurant.priceRangeAndDescription)
                        .font(.subheadline)
                        .foregroundColor(Color(UIColor.systemGray2))
                        .lineLimit(1)
                    Spacer()
                    Button (action: {
                        showDetails = true
                        }) {
                        Image("info").foregroundColor(appPrimaryColor)
                    }.buttonStyle(PlainButtonStyle())
                    .sheet(isPresented: $showDetails) {
                        RestaurantDetailsView(restaurant: $restaurant)
                    }
                }
            }
        }.padding(kHalfPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(UIColor.secondarySystemGroupedBackground))
        // Borderline: if selected, green; otherwise, light gray.
        .overlay(RoundedRectangle(cornerRadius: kCornerRadius / 2).stroke(isSelected ? appPrimaryColor : Color(UIColor.systemGray4), lineWidth: isSelected ? kSelectedBorderLineWidth : kBorderLineWidth))
        .padding(.horizontal, kDefaultPadding)
        .padding(.vertical, kHalfPadding)// Yes, another padding.  This will keep the borderline away from the edges.  The first one is to keep contents of row away from the border.
    }
}
