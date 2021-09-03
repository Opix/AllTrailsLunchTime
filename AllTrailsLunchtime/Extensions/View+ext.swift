//
//  View+hidden.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import SwiftUI

// Reference:
// https://www.fivestars.blog/articles/conditional-modifiers/
// if x then a
extension View {
    @ViewBuilder
    func `if`<Transform: View>(_ condition: Bool, transform: (Self) -> Transform) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// if x then a, else b
extension View {
    @ViewBuilder
    func `if`<TrueContent: View, FalseContent: View>(_ condition: Bool,
                                                        if ifTransform: (Self) -> TrueContent,
                                                        else elseTransform: (Self) -> FalseContent) -> some View {
        if condition {
            ifTransform(self)
        } else {
            elseTransform(self)
        }
    }
}

// if let x = y
extension View {
    @ViewBuilder
    func ifLet<V, Transform: View>(_ value: V?, transform: (Self, V) -> Transform) -> some View {
        if let value = value {
            transform(self, value)
        } else {
            self
        }
    }
}

extension View {
    func configureNavigationBar(configure: @escaping (UINavigationController) -> Void) -> some View {
        modifier(NavigationConfigurationViewModifier(configure: configure))
    }

    // Hide keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
