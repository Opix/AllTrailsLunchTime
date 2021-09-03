//
//  RestaurantDetailsView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct RestaurantDetailsView: View {
    @Binding var restaurant: RestaurantModel
    
    var body: some View {
        ScrollView (.vertical) {
            VStack (alignment: .center) {
                Text(restaurant.name)
                    .font(.title)
                    .bold()
                    .foregroundColor(appDarkGray)
                    .fixedSize(horizontal: false, vertical: true)

                if let ref = restaurant.photoReference {
                    let configurations = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
                    
                    if let url = configurations[apiPhotoUrlKey] as! String?,
                       let accessKey = configurations[apiAccessKey] as! String? {
                        WebImage(url: URL(string: "\(url)\(ref)&key=\(accessKey)"))
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
                            .frame(width: 300, height: 200, alignment: .center)
                    }
                }
                
                Text("Address")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(kHalfPadding)
                    .background(Color(UIColor.systemGray5))

                if let address = restaurant.address,
                    !address.isEmpty {
                    // NSMutableAttributedString is not supported in SwiftUI so use a button here.
                        Button (action: {
                            openGoogleMap(latitude: restaurant.latitude, longitude: restaurant.longitude)
                            }) {
                            Text(address)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .multilineTextAlignment(.leading)
                                .lineLimit(5)
                        }
                        .padding(.leading, kHalfPadding)
                } else {
                    Text("?")
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                        .padding(.leading, kHalfPadding)
                }
                Text("Rating")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(kHalfPadding)
                    .background(Color(UIColor.systemGray5))

                HStack {
                    RatingView(rating: $restaurant.rating)
                    Text(restaurant.rating.formatTo1Fraction)
                    Spacer()
                }
                .padding(.vertical, kHalfPadding / 2)
                .padding(.leading, kHalfPadding)

                Text("Customer Reviews Total")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(kHalfPadding)
                    .background(Color(UIColor.systemGray5))

                Text("\(restaurant.totalReviews)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, kHalfPadding)
                
                Text("Price Level")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(kHalfPadding)
                    .background(Color(UIColor.systemGray5))

                Text(restaurant.priceRangeAsDollarSigns)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, kHalfPadding)
            }.frame(alignment: .top).padding(kDefaultPadding)
            // For some reason I can not put too much of stuff in VStack...  Seriously?
            VStack (alignment: .center) {
                Text("Keywords")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(kHalfPadding)
                    .background(Color(UIColor.systemGray5))

                Text(restaurant.descriptionOrNA)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, kHalfPadding)
            }.frame(alignment: .top)
            .padding(.horizontal, kDefaultPadding)
            .padding(.top, -16)
            Spacer()
        }
    }
    
    private func openGoogleMap(latitude: Double, longitude: Double) {
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            if let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                UIApplication.shared.open(url, options: [:])
            }
            
        } else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(latitude),\(longitude)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
}
