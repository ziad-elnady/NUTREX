//
//  FoodSearchScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 26/03/2024.
//

import SwiftUI

struct NXRoutineMeal: Hashable {
    let name: String
    
    static let example: [NXRoutineMeal] = [
        NXRoutineMeal(name: "Breakfast"),
        NXRoutineMeal(name: "Lunch"),
        NXRoutineMeal(name: "Dinner"),
    ]
}

struct FoodSearchScreen: View {
    enum Field {
        case search
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @FocusState private var focusedField: Field?
    
    @State private var searchTerm = ""
    @State private var currentMeal = NXRoutineMeal.example[0]
    
    let routineMeals = NXRoutineMeal.example
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("search food", text: $searchTerm)
                        .focused($focusedField, equals: .search)
                        .submitLabel(.search)
                        .onSubmit {
                            print("Search foods")
                        }
                }
                .padding()
                .background {
                    Capsule()
                        .stroke(.gray.opacity(0.25), lineWidth: 0.5)
                }
                .foregroundStyle(.gray.opacity(0.45))
                .padding()
                Spacer()
            }
            .navigationTitle(currentMeal.name)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                focusedField = .search
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                }
            }
            .toolbarTitleMenu {
                Picker(selection: $currentMeal) {
                    ForEach(routineMeals, id: \.self) { routineMeal in
                        Text(routineMeal.name).tag(Optional(routineMeal.name))
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FoodSearchScreen()
    }
}
