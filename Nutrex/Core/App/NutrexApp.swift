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
    
    @StateObject var authStore = AuthenticationStore()
    @StateObject var userStore = UserStore()
    
    @State private var selectedDate = Date.now.onlyDate
    @State private var errorWrapper: ErrorWrapper?
    
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
            .environmentObject(authStore)
            .environmentObject(userStore)
            .environment(\.showError) { error, message in
                errorWrapper = ErrorWrapper(error: error, message: message)
            }
            .sheet(item: $errorWrapper) { errorWrapper in
                Text(errorWrapper.error.localizedDescription)
            }
            .tint(.nxAccent)
        }
        
    }
    
}
