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
    @StateObject var userStore = UserStore()
    
    let dataStore = CoreDataController.shared
    
    var body: some Scene {
        WindowGroup {
            
            AppCoordinator()
                .environment(\.managedObjectContext, dataStore.viewContext)
                .environmentObject(authStore)
                .environmentObject(userStore)
                .tint(.nxAccent)
            
        }
        
    }
    
}
