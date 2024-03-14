//
//  AppCoordinator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct AppCoordinator: View {
    @EnvironmentObject var authStore: AuthenticationStore
    @EnvironmentObject var userStore: UserStore
    
    @State private var isSignInPresented = false
        
    var body: some View {
        Group {
            if authStore.isAuthenticated && userStore.currentUser.isProfileCompleted {
                UserNutritionDiaryScreen(uid: authStore.userSession?.uid ?? "")
            } else if !authStore.isAuthenticated {
                AuthenticationScreen()
            } else if !userStore.currentUser.isProfileCompleted {
                ProfileSetupScreen()
            }
        }
        .fullScreenCover(isPresented: $isSignInPresented) {
            AuthenticationScreen()
        }
    }
}

struct UserNutritionDiaryScreen: View {
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject private var userStore: UserStore
    
    @FetchRequest private var users: FetchedResults<User>
        
    let uid: String
    
    init(uid: String) {
        self.uid = uid
        self._users = FetchRequest(fetchRequest: User.filteredUsersForID(uid))
    }
    
    var body: some View {
        if users.first == nil {
            VStack {
                Text("First Launch")
                
                Button("Create a user") {
                    let user = User(context: context)
                    
                    user.uid = uid
                    user.username = "Karim"
                    
                    try? context.save()
                }
            }
        } else {
            NutritionDiaryScreen(user: users.first!)
                .task {
                    userStore.currentUser = users.first!
                }
        }
    }
}

#Preview {
    AppCoordinator()
}
