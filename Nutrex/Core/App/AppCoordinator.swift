//
//  AppCoordinator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct AppCoordinator: View {
    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var userStore: UserStore
    
    @FetchRequest private var users: FetchedResults<User>
    @State private var isSignInPresented = false
        
    let uid: String
    
    init(uid: String) {
        self.uid = uid
        self._users = FetchRequest(fetchRequest: User.filteredUsersForID(uid))
    }
        
    var body: some View {
        Group {
            if userStore.currentUser.isNotEmpty {
                MainApp(user: userStore.currentUser)
            } else {
                AppLogo()
                    .frame(width: 220, height: 35)
            }
        }
        .task {
            await userStore.fetchUser(forId: uid)
        }
        .fullScreenCover(isPresented: $isSignInPresented) {
            AuthenticationScreen()
        }
    }
}


// MARK: - VIEWS -
extension AppCoordinator {
    
    @ViewBuilder
    private func MainApp(user: User) -> some View {
        Group {
            if user.isProfileCompleted {
                NutritionDiaryScreen()
                    .task {
                        await userStore.syncUser()
                    }
            } else {
                ProfileSetupScreen()
            }
        }
        .onAppear {
            userStore.currentUser = user
        }
    }
    
}

#Preview {
    AppCoordinator(uid: "123")
}
