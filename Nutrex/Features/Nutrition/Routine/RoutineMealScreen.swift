//
//  RoutineMealScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 07/05/2024.
//

import SwiftUI

struct RoutineMealScreen: View {
    @Environment(\.selectedDate) private var currentDate
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var routineMealStore: RoutineMealStore
    
    @State private var isShowingEditRoutineMeals = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(routineMealStore.routineMeals) { routineMeal in
                        NavigationLink(value: routineMeal) {
                            CollapsableRoutineMealRow(routineMealName: routineMeal.wrappedName)
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .padding(12.0)
            }
            .navigationBarTitleDisplayMode(.inline)
            .background {
                Color(.nxBackground)
                    .ignoresSafeArea()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "chevron.backward")
                            .captionFontStyle()
                        
                        Image(systemName: "calendar.badge.checkmark.rtl")
                        Text(formatDate(currentDate.wrappedValue))
                        
                        Image(systemName: "chevron.forward")
                            .captionFontStyle()
                    }
                    .overlay {
                        DatePicker(
                            "",
                            selection: currentDate,
                            displayedComponents: [.date]
                        )
                        .blendMode(.destinationOver)
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("edit") {
                        isShowingEditRoutineMeals = true
                    }
                }
            }
            .sheet(isPresented: $isShowingEditRoutineMeals) {
                RoutineMealsEditorSheet(user: userStore.currentUser)
            }
            .navigationDestination(for: RoutineMeal.self) { routineMeal in
                RoutineMealDetailScreen(routineMeal: routineMeal)
            }
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM"
        return dateFormatter.string(from: date)
    }
}

struct CollapsableRoutineMealRow: View {
    @State private var isCollapsed = true
    
    let routineMealName: String
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                    .padding(.trailing, 8.0)
                
                VStack(alignment: .leading) {
                    Text(routineMealName)
                        .bodyFontStyle()
                        .fontWeight(.semibold)
                    
                    Text("245 total cals")
                        .bodyFontStyle()
                        .foregroundStyle(.secondary)
                }
                .hSpacing(.leading)
                
                Image(systemName: "chevron.forward")
                    .captionFontStyle()
                    .foregroundStyle(.secondary)
                    .rotationEffect(isCollapsed ? .zero : .degrees(90.0))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    isCollapsed.toggle()
                }
            }
            
            if !isCollapsed {
                RoutineMealFoodsListView(routineMealName: routineMealName)
            }
        }
        .carded()
        
    }
}

struct RoutineMealFoodsListView: View {
    @EnvironmentObject private var nutritionStore: NutritionDiaryStore
    
    let routineMealName: String
    
    var foods: [Food] {
        nutritionStore.filterFoodsForMeal(mealName: routineMealName)
    }
    
    var body: some View {
        VStack {
            Divider()
            
            if foods.isEmpty {
                Text("no foods logged in this meal.")
                    .font(.caption)
                    .italic()
                    .foregroundStyle(.tertiary)
                    .multilineTextAlignment(.center)
            } else {
                ForEach(foods) { food in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(food.wrappedName)
                                .bodyFontStyle()
                                .fontWeight(.medium)
                                .hSpacing(.leading)
                            
                            Text("serving: " + food.serving.formattedNumber() + " x " + food.wrappedUnitName)
                                .captionFontStyle()
                                .foregroundStyle(.secondary)
                        }
                        
                        VStack(alignment: .trailing) {
                            Text(food.calculatedNutritionalInfo.calories.formattedNumber())
                                .bodyFontStyle()
                                .fontWeight(.bold)
                                .foregroundStyle(.nxAccent)
                            
                            Text("kcal")
                                .captionFontStyle()
                                .fontWeight(.semibold)
                                .foregroundStyle(.tertiary)
                        }
                    }
                    .padding(.top, 8.0)
                }
            }
        }
    }
}

#Preview {
    RoutineMealScreen()
        .environmentObject(UserStore())
        .environmentObject(RoutineMealStore())
}
