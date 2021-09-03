//
//  MyProgressView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 9/2/21.
//

import SwiftUI

struct MyProgressView: View {
    var body: some View {
        GeometryReader { geo in
            ProgressView()
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .background(Color(UIColor.systemGray6))
                    .opacity(0.8)
        }
    }
}

struct MyProgressView_Previews: PreviewProvider {
    static var previews: some View {
        MyProgressView()
    }
}
