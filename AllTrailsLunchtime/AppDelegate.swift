//
//  AppDelegate.swift
//  AllTrailsLunchtime
//
//  Created by Osamu Chiba on 9/1/21.
//  Copyright © 2021 Opix. All rights reserved.
//
// Reference:
// https://blckbirds.com/post/how-to-use-google-maps-in-swiftui-apps/

import Foundation
import SwiftUI
import GoogleMaps

class AppDelegate: NSObject, UIApplicationDelegate    {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let configurations = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Info", ofType: "plist")!)!
        
        guard let accessKey = configurations[apiAccessKey] as! String? else {
            return false
        }
        GMSServices.provideAPIKey(accessKey)
        return true
    }
}
