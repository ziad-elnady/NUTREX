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
    
    enum NutritionCategory: CaseIterable, Hashable {
        case preWorkouts
        case protein
        case carbs
        case fats
        case lowCarb
        
        var title: String {
            switch self {
            case .preWorkouts:
                return "Pre-Wks"
            case .protein:
                return "Protein"
            case .carbs:
                return "Carbs"
            case .fats:
                return "Fats"
            case .lowCarb:
                return "Low-Carb"
            }
        }
        
        var imageName: String {
            switch self {
            case .preWorkouts:
                return "food-1"
            case .protein:
                return "food-2"
            case .carbs:
                return "food-3"
            case .fats:
                return "food-4"
            case .lowCarb:
                return "food-5"
            }
        }
    }
    
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var nutritionStore: NutritionDiaryStore
    @EnvironmentObject private var routineMealStore: RoutineMealStore
    
    @FocusState private var focusedField: Field?
    
    @State private var searchTerm   = ""
    @State private var currentTab   = 0
    @State private var isShowingSearchResults = false
    @State private var isShowingFoodScannerScreen = false
    
    @State private var foods: [Food] = []
    
    private var searchResults: [Food] {
        if searchTerm.isEmpty {
            return []
        } else {
            return foods.filter { $0.wrappedName.contains(searchTerm) }
        }
    }
    
    let tabBarOptions = ["Foods", "Meals", "Supplements"]
    let savedMeals = ["MyFav"]
    
    let didSelectFood: (Food) -> Void
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("search food", text: $searchTerm)
                        .focused($focusedField, equals: .search)
                        .submitLabel(.search)
                        .onSubmit {
                            if !searchTerm.isEmpty {
                                isShowingSearchResults = true
                            }
                        }
                }
                .padding(.vertical, 12.0)
                .padding(.horizontal)
                .foregroundStyle(.gray.opacity(0.45))
                .background {
                    Capsule()
                        .fill(Color(.nxCard))
                }
                .padding(.vertical, 8.0)
                .padding(.horizontal)
                
                NXAnimatedTabbarView(currentTab: $currentTab, tabBarOptions: tabBarOptions)
                    .padding(.horizontal)
                    .padding(.bottom, 0.0)
                
                Divider()
                
                if isShowingSearchResults {
                    SearchResultsView()
                } else {
                    TabView(selection: $currentTab) {
                        FoodsPage().tag(0)
                        MealsPage().tag(1)
                        Text("Supplements").tag(2)
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                }
            }
            .vSpacing(.top)
            .background {
                Color(.nxBackground)
                    .ignoresSafeArea()
            }
            .navigationTitle(routineMealStore.currentMeal ?? "Select a Meal")
            .navigationBarTitleDisplayMode(.inline)
            .ignoresSafeArea(.keyboard)
            .onAppear {
                focusedField = .search
            }
            .task {
                foods = NutritionDiaryStore.foods
            }
            .onChange(of: searchTerm) {
                if searchTerm.isEmpty {
                    isShowingSearchResults = false
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingFoodScannerScreen = true
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                }
            }
            .toolbarTitleMenu {
                Picker("", selection: $routineMealStore.currentMeal) {
                    ForEach(routineMealStore.routineMeals, id: \.objectID) { routineMeal in
                        Text(routineMeal.wrappedName).tag(Optional(routineMeal.wrappedName))
                    }
                }
            }
            .navigationDestination(for: Food.self) { food in
                FoodDetailScreen(food: food) { food in
                    logFood(food: food)
                }
            }
            .navigationDestination(for: HistoryItem.self) { historyItem in
                FoodDetailScreen(food: historyItem.wrappedFood) { food in
                    logFood(food: food)
                }
            }
            .navigationDestination(for: Meal.self) { meal in
                MealDetailScreen()
            }
            .fullScreenCover(isPresented: $isShowingFoodScannerScreen) {
                QRFoodScannerScreen()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FoodSearchScreen() { _ in }
    }
    .environmentObject(UserStore())
    .environmentObject(RoutineMealStore())
}

// MARK: - VIEWS -
extension FoodSearchScreen {
    
    
    @ViewBuilder
    private func FoodsPage() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16.0) {
                VStack(alignment: .leading, spacing: 2.0) {
                    Text("Categories by need")
                        .sectionHeaderFontStyle()
                    
                    Text("filters foods for your needs.")
                        .foregroundStyle(.secondary)
                        .captionFontStyle()
                }
                .padding(.leading)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16.0) {
                        ForEach(NutritionCategory.allCases, id: \.self) { category in
                            VStack {
                                Circle()
                                    .frame(width: 60.0, height: 60.0)
                                    .overlay {
                                        Image(category.imageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 32.0, height: 32.0)
                                    }
                                    .foregroundColor(Color(.nxCard))
                                
                                Text(category.title)
                                    .captionFontStyle()
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 60)
                        }
                    }
                    .padding(.leading)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top, 12.0)
            
            Historylist(sortOption: .mostRecent, didSelectFood: didSelectFood)
                .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    private func MealsPage() -> some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 16.0) {
                VStack(alignment: .leading, spacing: 2.0) {
                    Text("My Meals")
                        .sectionHeaderFontStyle()
                    
                    Text("these are custom meals created by you.")
                        .foregroundStyle(.secondary)
                        .captionFontStyle()
                }
                .padding(.leading)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 16.0) {
                        ForEach(savedMeals, id: \.self) { meal in
                            NavigationLink(value: meal) {
                                VStack {
                                    Circle()
                                        .frame(width: 60.0, height: 60.0)
                                        .overlay {
                                            Image("food-\(Int.random(in: 1...4))")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 32.0, height: 32.0)
                                        }
                                        .foregroundColor(Color(.nxCard))
                                    
                                    Text(meal)
                                        .captionFontStyle()
                                        .foregroundStyle(.gray)
                                }
                            }
                            .frame(width: 60)
                        }
                        
                        VStack {
                            Circle()
                                .frame(width: 60.0, height: 60.0)
                                .foregroundColor(Color(.nxCard))
                                .overlay {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundStyle(.secondary)
                                        .frame(width: 32.0, height: 32.0)
                                }
                            
                            Text("Create")
                                .captionFontStyle()
                                .foregroundStyle(.secondary)
                        }
                        .frame(width: 60)
                    }
                    .padding(.leading)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.top, 12.0)
            
            VStack(alignment: .leading, spacing: 2.0) {
                Text("Recent logs")
                    .sectionHeaderFontStyle()
                
                Text("browse you recents.")
                    .foregroundStyle(.secondary)
                    .captionFontStyle()
                
                ContentUnavailableView("No Loggs Yet.",
                                       systemImage: "tray",
                                       description: Text("Any food you log will be saved in\nthis section for easier logs"))
            }
            .padding(.top)
            .padding(.leading)
        }
    }
    
    @ViewBuilder
    private func SearchResultsView() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 2.0) {
                Text("Results")
                    .sectionHeaderFontStyle()
                
                Text("a wide database for all foods")
                    .foregroundStyle(.secondary)
                    .captionFontStyle()
            }
            .hSpacing(.leading)
            .padding(.leading, 12.0)
            
            ForEach(searchResults, id: \.objectID) { food in
                NavigationLink(value: food) {
                    HStack {
                        Group {
                            VStack(alignment: .leading) {
                                Text(food.wrappedName)
                                    .sectionHeaderFontStyle()
                                Text("calories: \(food.wrappedNutritionalInfo.caloriesPerGram.formatCalories()) kcal")
                                    .captionFontStyle()
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        if routineMealStore.currentMeal == nil {
                            Menu {
                                ForEach(routineMealStore.routineMeals, id: \.self) { routineMeal in
                                    Button {
                                        routineMealStore.currentMeal = routineMeal.wrappedName
                                        food.meal = routineMeal.wrappedName
                                        
                                        didSelectFood(food)
                                    } label: {
                                        Text(routineMeal.wrappedName).tag(Optional(routineMeal.name))
                                    }
                                }
                            } label: { 
                                Circle()
                                    .frame(width: 32.0, height: 32.0)
                                    .foregroundStyle(Color(.nxBackground))
                                    .overlay {
                                        Image(systemName: "plus")
                                            .sectionHeaderFontStyle()
                                            .foregroundStyle(.nxAccent)
                                    }
                            }
                        } else  {
                            Button {
                                food.meal = routineMealStore.currentMeal
                                
                                didSelectFood(food)
                            } label: {
                                Circle()
                                    .frame(width: 32.0, height: 32.0)
                                    .foregroundStyle(Color(.nxBackground))
                                    .overlay {
                                        Image(systemName: "plus")
                                            .sectionHeaderFontStyle()
                                            .foregroundStyle(.nxAccent)
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 12.0)
                    .padding(.horizontal)
                    .background {
                        Color(.nxCard)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
            }
            .overlay {
                if foods.isEmpty {
                    ContentUnavailableView.search(text: searchTerm)
                }
            }
            .foregroundStyle(.primary)
        }
        .scrollIndicators(.hidden)
        .hSpacing(.leading)
        .padding(.horizontal)
    }
    
    
}

// MARK: - VIEWS -
extension FoodSearchScreen {
    
    enum SortOption: String, CaseIterable {
        case mostRecent = "most recent"
        case mostFrequent = "most frequent"
    }
    
    struct Historylist: View {
        @FetchRequest var historyItems: FetchedResults<HistoryItem>
        
        @EnvironmentObject private var routineMealStore: RoutineMealStore
        
        let didSelectFood: (Food) -> Void
        
        init(sortOption: SortOption, didSelectFood: @escaping (Food) -> Void) {
            switch sortOption {
            case .mostFrequent:
                _historyItems = FetchRequest<HistoryItem>(sortDescriptors: [SortDescriptor(\.repetition)])
            case .mostRecent:
                _historyItems = FetchRequest<HistoryItem>(sortDescriptors: [SortDescriptor(\.createdAt)])
            }
            
            self.didSelectFood = didSelectFood
        }
        
        var body: some View {
            VStack(alignment: .leading, spacing: 2.0) {
                Text("Recently logged")
                    .sectionHeaderFontStyle()
                
                Text("recent foods will be here.")
                    .foregroundStyle(.secondary)
                    .captionFontStyle()
            }
            .hSpacing(.leading)
            .padding(.top, 12.0)
            
            if historyItems.isEmpty {
                ContentUnavailableView("No Loggs Yet.",
                                       systemImage: "tray",
                                       description: Text("Any food you log will be saved in\nthis section for easier logs"))
                .padding(.top, 48.0)
            }
            
            ForEach(historyItems, id: \.objectID) { historyItem in
                NavigationLink(value: historyItem) {
                    HStack {
                        Group {
                            VStack(alignment: .leading) {
                                Text(historyItem.wrappedText)
                                    .sectionHeaderFontStyle()
                                Text("serving: \(historyItem.serving.formattedNumber()), unit: \(historyItem.wrappedUnit)")
                                    .captionFontStyle()
                                    .foregroundStyle(.secondary)
                            }
                            
                            Spacer()
                        }
                        
                        if routineMealStore.currentMeal == nil {
                            Menu {
                                ForEach(routineMealStore.routineMeals, id: \.self) { routineMeal in
                                    Button {
                                        routineMealStore.currentMeal = routineMeal.wrappedName
                                        historyItem.wrappedFood.meal = routineMeal.wrappedName
                                        
                                        didSelectFood(historyItem.wrappedFood)
                                    } label: {
                                        Text(routineMeal.wrappedName).tag(Optional(routineMeal.name))
                                    }
                                }
                            } label: {
                                Circle()
                                    .frame(width: 32.0, height: 32.0)
                                    .foregroundStyle(Color(.nxBackground))
                                    .overlay {
                                        Image(systemName: "plus")
                                            .sectionHeaderFontStyle()
                                            .foregroundStyle(.nxAccent)
                                    }
                            }
                        } else  {
                            Button {
                                historyItem.food?.meal = routineMealStore.currentMeal
                                
                                didSelectFood(historyItem.food ?? Food.example)
                            } label: {
                                Circle()
                                    .frame(width: 32.0, height: 32.0)
                                    .foregroundStyle(Color(.nxBackground))
                                    .overlay {
                                        Image(systemName: "plus")
                                            .sectionHeaderFontStyle()
                                            .foregroundStyle(.nxAccent)
                                    }
                            }
                        }
                    }
                    .padding(.vertical, 12.0)
                    .padding(.horizontal)
                    .background {
                        Color(.nxCard)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
                .foregroundStyle(.primary)
            }
            .hSpacing(.leading)
            .vSpacing(.top)
        }
    }
}

// MARK: - ACTIONS -
extension FoodSearchScreen {
    
    private func logFood(food: Food) {
        nutritionStore.logFood(food: food,
                               forRoutineMeal: routineMealStore.currentMeal)
        dismiss()
    }
    
}
