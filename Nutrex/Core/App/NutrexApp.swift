//
//  NutrexApp.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 08/03/2024.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct NutrexApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var authStore = AuthenticationStore()
    
    var body: some Scene {
        WindowGroup {
            
            AppCoordinator()
                .environmentObject(authStore)
                .tint(.nxAccent)
            
        }
        
    }
    
}
