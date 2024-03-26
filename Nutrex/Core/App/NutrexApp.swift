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
    @State private var isShowingSplashScreen = true
    
    var body: some Scene {
        WindowGroup {
            RootView {
                ZStack {
                    if let userSession = authStore.userSession {
                        AppCoordinator(uid: userSession.uid,
                                       isShowingSplashScreen: $isShowingSplashScreen)
                    } else {
                        AuthenticationScreen()
                            .task(priority: .userInitiated) {
                                if authStore.userSession == nil {
                                    isShowingSplashScreen = false
                                }
                            }
                    }
                }
                .overlay {
                    if isShowingSplashScreen {
                        SplashLoadingScreen()
                    }
                }
                .transition(.slide)
            }
            .environment(\.managedObjectContext, dataStore.viewContext)
            .environment(\.selectedDate, $selectedDate)
            .environmentObject(authStore)
            .environmentObject(userStore)
            .tint(.nxAccent)
        }
        
    }
    
}
