//
//  AppCoordinator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct AppCoordinator: View {
    @FetchRequest private var users: FetchedResults<User>
    @EnvironmentObject private var userStore: UserStore
    
    @StateObject var nutritionStore = NutritionDiaryStore()
    
    @Binding var isShowingSplashScreen: Bool
        
    let uid: String
    
    init(uid: String, isShowingSplashScreen: Binding<Bool>) {
        self.uid = uid
        self._isShowingSplashScreen = isShowingSplashScreen
        self._users = FetchRequest(fetchRequest: User.filteredUsersForID(uid))
    }
    
    var body: some View {
        ZStack {
            if userStore.currentUser.isProfileCompleted {
                NutritionTabView()
                    .environmentObject(nutritionStore)
            } else {
                ProfileSetupScreen()
            }
        }
        .task(priority: .low) {
            if let user = users.first {
                userStore.currentUser = user
            }
            
            try? await userStore.fetchUser(forId: uid)
            
            isShowingSplashScreen = false
        }
    }
}

#Preview {
    AppCoordinator(uid: "empty", isShowingSplashScreen: .constant(false))
}


