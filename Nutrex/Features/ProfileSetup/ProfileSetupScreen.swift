//
//  ProfileSetupScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import FirebaseAuth
import SwiftUI

struct ProfileSetupScreen: View {
    var body: some View {
        VStack {
            Text("Profile Setup Screen")
            Button("Sign Out") {
                try? Auth.auth().signOut()
            }
        }
    }
}

#Preview {
    ProfileSetupScreen()
}
