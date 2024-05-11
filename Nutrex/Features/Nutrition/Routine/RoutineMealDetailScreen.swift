//
//  RoutineMealDetailScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 11/05/2024.
//

import SwiftUI

struct RoutineMealDetailScreen: View {
    
    @EnvironmentObject private var nutritionStore: NutritionDiaryStore
    @EnvironmentObject private var routineMealStore: RoutineMealStore
    
    let routineMeal: RoutineMeal
    
    var foods: [Food] {
        nutritionStore.filterFoodsForMeal(mealName: routineMeal.wrappedName)
    }
        
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("Calories")
                    Spacer()
                    Text("240")
                }
                .carded()
                
                NXSectionView(header: "Foods") {
                    ForEach(foods) { food in
                        HStack {
                            Text(food.wrappedName)
                            
                            Spacer()
                            
                            Text(food.calculatedNutritionalInfo.calories.formattedNumber() + " kcal")
                        }
                        .carded()
                    }
                }
                .padding(.top)
            }
            .padding()
        }
        .toolbarTitleMenu {
            Picker(routineMeal.wrappedName, selection: $routineMealStore.currentMeal) {
                ForEach(routineMealStore.routineMeals, id: \.objectID) { routineMeal in
                    Text(routineMeal.wrappedName).tag(Optional(routineMeal.wrappedName))
                }
            }
        }
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
    }
}

#Preview {
    NavigationStack {
        RoutineMealDetailScreen(routineMeal: RoutineMeal.defaultMeals()[0])
            .environmentObject(NutritionDiaryStore())
            .environmentObject(RoutineMealStore())
    }
}
