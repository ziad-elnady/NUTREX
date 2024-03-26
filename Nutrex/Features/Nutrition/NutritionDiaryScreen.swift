//
//  NutritionDiaryScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct NutritionDiaryScreen: View {
    @Environment(\.selectedDate) private var selectedDate
    
    @EnvironmentObject private var authStore: AuthenticationStore
    @EnvironmentObject private var userStore: UserStore
    
    @State private var alert: NXGenericAlert? = nil
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HeaderView(date: selectedDate)
                    .vSpacing(.top)
            }
            .showAlert(alert: $alert)
        }
    }
}

// MARK: - VIEWS -
extension NutritionDiaryScreen {
    
}


// MARK: - ACTIONS -
extension NutritionDiaryScreen {
    
}

#Preview {
    NutritionDiaryScreen()
}
