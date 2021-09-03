//
//  SwitchView.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/27/21.
//

import SwiftUI

struct SwitchView: View {
    @Binding var isList: Bool
    var onSwitchTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            Button (action: {
                self.hideKeyboard()
                self.onSwitchTapped()
            }) {
                HStack {
                    Image(isList ? "place": "list").foregroundColor(Color.white)
                    Text(isList ? "Map" : "List").foregroundColor(Color.white)
                }
            }.buttonStyle(PlainButtonStyle())
            .frame(width: 100, height: 60, alignment: .center)
            .background(appPrimaryColor)
            .cornerRadius(12)
            .shadow(radius: kCornerRadius / 2)
            .padding(.bottom, 42)
        }
    }
}

struct SwitchView_Previews: PreviewProvider {
    static var previews: some View {
        SwitchView(isList: .constant(true), onSwitchTapped: {
        })
    }
}
