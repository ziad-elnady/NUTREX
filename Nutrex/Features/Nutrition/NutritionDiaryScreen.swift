//
//  NutritionDiaryScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import FirebaseAuth
import SwiftUI

struct NutritionDiaryScreen: View {
    @EnvironmentObject private var authStore: AuthenticationStore
    @EnvironmentObject private var userStore: UserStore
    
    @State private var alert: NXGenericAlert? = nil
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(userStore.currentUser.wrappedUid)
                Text(userStore.currentUser.wrappedName)
                Text(userStore.currentUser.wrappedGoal)
                Text(userStore.currentUser.wrappedEmail)
                Text(userStore.currentUser.wrappedGender)
                Text(userStore.currentUser.bodyType ?? "sss")
                
                Text("needed calories: \(Int(userStore.currentUser.neededCalories))")
                    .font(.title)
                    .padding()
                
                Button("Sign Out") {
                    Task {
                        do {
                            try await authStore.signOut()
                            userStore.currentUser = User.empty
                        } catch {
                            alert = .dataNotFound(onRetryPressed: {
                                
                            })
                        }
                    }
                }
                .buttonStyle(.bordered)
                .padding()
            }
            .navigationTitle("Nutrition Diary")
            .showAlert(alert: $alert)
        }
    }
}

#Preview {
    NutritionDiaryScreen()
}
