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
    
    @State private var isShowingFoodSearchScreen = false
    @State private var mealTime = Date()
    
    @State private var selectedFood: Food? = nil
    
    let routineMeal: RoutineMeal
    
    var foods: [Food] {
        nutritionStore.filterFoodsForMeal(mealName: routineMealStore.currentMeal ?? routineMeal.wrappedName)
    }
    
    var totalNutrients: (calories: Double, protein: Double, carbs: Double, fat: Double) {
        nutritionStore.calculateTotalNutrientsForFoods(foods: foods)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                HStack {
                    Group {
                        VStack {
                            Text("calories")
                                .bodyFontStyle()
                                .foregroundStyle(.secondary)
                            
                            Text(totalNutrients.calories.formattedNumber())
                                .headlineFontStyle()
                                .fontWeight(.medium)
                        }
                        
                        VStack {
                            Text("protein")
                                .bodyFontStyle()
                                .foregroundStyle(.secondary)
                            
                            Text(totalNutrients.protein.formattedNumber())
                                .headlineFontStyle()
                                .fontWeight(.medium)
                        }
                        
                        VStack {
                            Text("carbs")
                                .bodyFontStyle()
                                .foregroundStyle(.secondary)
                            
                            Text(totalNutrients.carbs.formattedNumber())
                                .headlineFontStyle()
                                .fontWeight(.medium)
                        }
                        
                        VStack {
                            Text("fat")
                                .bodyFontStyle()
                                .foregroundStyle(.secondary)
                            
                            Text(totalNutrients.fat.formattedNumber())
                                .headlineFontStyle()
                                .fontWeight(.medium)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .carded()
                .padding()
                
                VStack {
                    HStack {
                        Text("reminder (optional)")
                            .bodyFontStyle()
                            .fontWeight(.medium)
                        
                        Spacer()
                        
                        DatePicker("", selection: $mealTime, displayedComponents: .hourAndMinute)
                    }
                    
                    Text("you can set a reminder that notifies you when this meal's time comes")
                        .captionFontStyle()
                        .foregroundStyle(.tertiary)
                }
                .carded()
                .padding(.horizontal)
                
                NXSectionView(header: "Foods") {
                    if foods.isEmpty {
                        ContentUnavailableView("no foods", systemImage: "tray", description: Text("no logged foods in this meal"))
                    } else {
                        ForEach(foods) { food in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(food.wrappedName)
                                        .bodyFontStyle()
                                        .fontWeight(.medium)
                                    
                                    Text("serving is \(food.wrappedUnitName) x\(food.serving.formattedNumber())")
                                        .captionFontStyle()
                                        .foregroundStyle(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack(spacing: 4.0) {
                                    Text(food.calculatedNutritionalInfo.calories.formattedNumber())
                                        .bodyFontStyle()
                                        .fontWeight(.bold)
                                    
                                    Text("kcal")
                                        .captionFontStyle()
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .carded()
                            .onTapGesture {
                                selectedFood = food
                            }
                        }
                    }
                }
                .padding(.top, 16.0)
                .padding(.horizontal)
            }
            
            .hSpacing(.leading)
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            routineMealStore.currentMeal = routineMeal.wrappedName
        }
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
                        
                        Text(routineMealStore.currentMeal ?? routineMeal.wrappedName)
                            .bodyFontStyle()
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                    }
                }
                .hSpacing(.center)
            }
            
            ToolbarItem {
                Button {
                   isShowingFoodSearchScreen = true
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
                        .captionFontStyle()
                        .fontWeight(.semibold)
                }
                .foregroundStyle(.white)
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .background {
            Color(.nxBackground)
                .ignoresSafeArea()
        }
        .fullScreenCover(isPresented: $isShowingFoodSearchScreen) {
            FoodSearchScreen() { food in
                logFood(food: food)
            }
        }
        .sheet(item: $selectedFood) { food in
            FoodDetailScreen(food: food) { _ in }
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

// MARK: - ACTIONS -
extension RoutineMealDetailScreen {
    
    private func logFood(food: Food) {
        nutritionStore.logFood(food: food,
                               forRoutineMeal: routineMeal.wrappedName)
    }
    
}

#Preview {
    NavigationStack {
        RoutineMealDetailScreen(routineMeal: RoutineMeal.defaultMeals()[0])
            .environmentObject(NutritionDiaryStore())
            .environmentObject(RoutineMealStore())
    }
}


struct NewCircularProgressBar: View {
    enum LineWidth {
        case thin, regular, thick
        case custom(CGFloat)
        
        var value: CGFloat {
            switch self {
            case .thin:
                return 0.04
            case .regular:
                return 0.08
            case .thick:
                return 0.12
            case .custom(let width):
                return width
            }
        }
    }
    
    let progress: Double
    let progressColor: Color
    let lineWidth: LineWidth
    var description: String? = nil
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: lineWidth.value * min(geometry.size.width, geometry.size.height),
                                               lineCap: .round,
                                               lineJoin: .round))
                    .foregroundColor(.gray.opacity(0.2))
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(progress))
                    .stroke(style: StrokeStyle(lineWidth: lineWidth.value * min(geometry.size.width, geometry.size.height),
                                               lineCap: .round,
                                               lineJoin: .round))
                    .foregroundColor(progressColor)
                    .rotationEffect(Angle(degrees: -90))
                
                VStack(spacing: 4.0) {
                    Text(String(format: "%.0f%%", progress * 100))
                        .captionFontStyle()
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    if let desc = description {
                        Text(desc)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
