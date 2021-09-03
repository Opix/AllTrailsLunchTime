//
//  View+hidden.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 7/12/21.
//  Copyright © 2021 Opix. All rights reserved.
//

import SwiftUI

struct NavigationConfigurationViewModifier: ViewModifier {
    let configure: (UINavigationController) -> Void

    func body(content: Content) -> some View {
        content.background(NavigationConfigurator(configure: configure))
    }
}
