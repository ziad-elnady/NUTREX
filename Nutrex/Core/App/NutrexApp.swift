//
//  NutrexApp.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 08/03/2024.
//

import FirebaseCore
import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct NutrexApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    let dataStore = CoreDataController.shared
    let firebaseStore = FirestoreStore.shared
    
    @StateObject var authStore = AuthenticationStore.shared
    @StateObject var userStore = UserStore()
    
    @State private var selectedDate = Date.now.onlyDate
    
    var body: some Scene {
        WindowGroup {
            RootView {
                Group {
                    if let userSession = authStore.userSession {
                        AppCoordinator(uid: userSession.uid)
                    } else {
                        AuthenticationScreen()
                    }
                }
            }
            .environment(\.managedObjectContext, dataStore.viewContext)
            .environment(\.selectedDate, $selectedDate)
            .environmentObject(authStore)
            .environmentObject(userStore)
            .tint(.nxAccent)
        }
        
    }
    
}
