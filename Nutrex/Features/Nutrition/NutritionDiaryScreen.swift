//
//  NutritionDiaryScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct NutritionDiaryScreen: View {
    let user: User
    
    var body: some View {
        VStack {
            Text(user.wrappedName)
            Text(user.wrappedGoal)
            Text(user.wrappedEmail)
            Text(user.wrappedGender)
            Text(user.wrappedUid)
        }
    }
}

#Preview {
    NutritionDiaryScreen(user: User.empty)
}
