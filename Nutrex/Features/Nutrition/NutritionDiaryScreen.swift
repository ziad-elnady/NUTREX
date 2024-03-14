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
        Text(user.wrappedName)
    }
}

#Preview {
    NutritionDiaryScreen(user: User.empty)
}
