//
//  AppCoordinator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct AppCoordinator: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @State private var isSignInPresented = false
    
    //TODO: Add the required logic for determining if the profile if the user is finished (computer prop on user)
    private var isProfileSetupNeeded = true
    
    var body: some View {
        Group {
            if authStore.isAuthenticated && !isProfileSetupNeeded {
                NutritionDiaryScreen()
            } else if !authStore.isAuthenticated {
                AuthenticationScreen()
            } else if isProfileSetupNeeded {
                ProfileSetupScreen()
            }
        }
        .fullScreenCover(isPresented: $isSignInPresented) {
            AuthenticationScreen()
        }
    }
}

#Preview {
    AppCoordinator()
}
