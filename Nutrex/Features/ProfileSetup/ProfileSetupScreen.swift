//
//  ProfileSetupScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import FirebaseAuth
import SwiftUI

struct ProfileSetupScreen: View {
    @Environment(\.managedObjectContext) private var context
    
    @EnvironmentObject private var userStore: UserStore
    
    var body: some View {
        VStack {
            Text("Profile Setup Screen")
            Button("Sign Out") {
                try? Auth.auth().signOut()
            }
            Button("Complete Profile") {
                let user = userStore.currentUser
                
                user.bodyType = BodyType.ectomorph.rawValue
                user.goal = Goal.weightGain.rawValue
                user.weight = 80.0
                user.height = 182.0
                user.dateOfBirth = Date.now.onlyDate
                user.gender = Gender.male.rawValue
                
                CoreDataController.shared.saveContext()
                
                Task {
                    await userStore.saveUser(user)
                }
            }
        }
    }
}

#Preview {
    ProfileSetupScreen()
}
