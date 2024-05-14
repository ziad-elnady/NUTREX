//
//  RoutineMealDetailScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 11/05/2024.
//

import SwiftUI

struct RoutineMealDetailScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var nutritionStore: NutritionDiaryStore
    @EnvironmentObject private var routineMealStore: RoutineMealStore
    
    let routineMeal: RoutineMeal
    
    var foods: [Food] {
        nutritionStore.filterFoodsForMeal(mealName: routineMeal.wrappedName)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0.0, pinnedViews: [.sectionHeaders]) {
                Section {
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
                    }
                } header: {
//                    HeaderActions()
                }
                .padding()
            }
        }
        .navigationTitle(routineMeal.wrappedName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Menu {
                    Picker("", selection: $routineMealStore.currentMeal) {
                        ForEach(routineMealStore.routineMeals, id: \.objectID) { routineMeal in
                            Text(routineMeal.wrappedName).tag(Optional(routineMeal.wrappedName))
                        }
                    }
                } label: {
                    HStack(spacing: 6.0) {
                        Image(systemName: "chevron.down")
                            .captionFontStyle()
                            .fontWeight(.regular)
                            .foregroundStyle(.white)
                        
                        Text(routineMeal.wrappedName)
                            .bodyFontStyle()
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
                .hSpacing(.center)
            }
            
            ToolbarItem {
                Button {
                   
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .headlineFontStyle()
                        .fontWeight(.semibold)
                }
            }
            
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                }
            }
        }
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
    }
}

// MARK: - VIEWS -
extension RoutineMealDetailScreen {
    
    @ViewBuilder
    private func HeaderActions() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.body)
            }
            .foregroundStyle(.primary)
            .frame(width: 50, height: 50)
            .background {
                Circle()
                    .fill(Color(.nxCard))
            }
                        
            Menu {
                Picker("", selection: $routineMealStore.currentMeal) {
                    ForEach(routineMealStore.routineMeals, id: \.objectID) { routineMeal in
                        Text(routineMeal.wrappedName).tag(Optional(routineMeal.wrappedName))
                    }
                }
            } label: {
                HStack(spacing: 6.0) {
                    Image(systemName: "chevron.down")
                        .captionFontStyle()
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Text(routineMeal.wrappedName)
                        .headlineFontStyle()
                        .foregroundStyle(.white)
                }
            }
            .hSpacing(.center)
            
            HStack(spacing: 8.0) {
                Button {
                    
                } label: {
                    Image(systemName: "plus")
                        .font(.title2.bold())
                }
                .foregroundStyle(.invertedPrimary)
                .frame(width: 50, height: 50)
                .background {
                    Circle()
                        .fill(Color(.nxAccent))
                }
            }
        }
    }
    
//    @ViewBuilder
//    private func MealPicker() -> some View {
//        let meals = ["Breakfast", "Lunch", "Dinner"]
//        let selected = meals[0]
//        
//        HStack {
//            ForEach(meals, id: \.self) { meal in
//                Text(meal)
//                    .bodyFontStyle()
//                    .fontWeight(.semibold)
//                    .foregroundStyle(meal == selected ? .invertedPrimary : .primary)
//                    .padding(.horizontal, 16.0)
//                    .padding(.vertical, 8.0)
//                    .background(meal == selected ? .nxAccent : .clear)
//                    .clipShape(Capsule())
//                    .hSpacing(.center)
//            }
//        }
//        .hSpacing(.leading)
//        .padding()
//        .scrollIndicators(.hidden)
//        .background {
//            Color(.nxCard)
//                .ignoresSafeArea()
//        }
//    }
    
}

#Preview {
    NavigationStack {
        RoutineMealDetailScreen(routineMeal: RoutineMeal.defaultMeals()[0])
            .environmentObject(NutritionDiaryStore())
            .environmentObject(RoutineMealStore())
    }
}
