//
//  AllTrailsLunchtimeApp.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 8/26/21.
//

import SwiftUI

@main
struct AllTrailsLunchtimeApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
