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
    @EnvironmentObject private var nutritionStore: NutritionDiaryStore
    
    @FocusState private var focusedField: Field?
    
    @State private var searchTerm   = ""
    @State private var currentMeal  = NXRoutineMeal.example[0]
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
    
    let routineMeals = NXRoutineMeal.example
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
                
                AnimatedTabView(currentTab: $currentTab, tabBarOptions: tabBarOptions)
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
            .navigationTitle(currentMeal.name)
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
                Picker(selection: $currentMeal) {
                    ForEach(routineMeals, id: \.self) { routineMeal in
                        Text(routineMeal.name).tag(Optional(routineMeal.name))
                    }
                } label: {
                    Image(systemName: "trash")
                }
            }
            .navigationDestination(for: Food.self) { food in
                FoodDetailScreen(food: food) { food in
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
}

// MARK: - VIEWS -
extension FoodSearchScreen {
    
    
    @ViewBuilder
    private func FoodsPage() -> some View {
        VStack {
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
            
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 2.0) {
                    Text("Recently logged")
                        .sectionHeaderFontStyle()
                    
                    Text("recent foods will be here.")
                        .foregroundStyle(.secondary)
                        .captionFontStyle()
                }
                    .padding(.leading)
                
                ContentUnavailableView("No Loggs Yet.",
                                       systemImage: "tray",
                                       description: Text("Any food you log will be saved in\nthis section for easier logs"))
            }
            .padding(.top, 12.0)
        }
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
                //                    NavigationLink(value: food) {
                //                        VStack(alignment: .leading) {
                //                            Text(food.wrappedName)
                //                                .sectionHeaderFontStyle()
                //                            Text("calories: \(food.wrappedNutritionalInfo.caloriesPerGram.formatCalories()) kcal")
                //                                .captionFontStyle()
                //                                .foregroundStyle(.secondary)
                //                        }
                //                    }
                
                NavigationLink(value: food) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(food.wrappedName)
                                .sectionHeaderFontStyle()
                            Text("calories: \(food.wrappedNutritionalInfo.caloriesPerGram.formatCalories()) kcal")
                                .captionFontStyle()
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        Button {
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
            .listStyle(.plain)
        }
        .hSpacing(.leading)
        .padding(.horizontal)
    }
    
    
}

// MARK: - ACTIONS -
extension FoodSearchScreen {
    
    private func logFood(food: Food) {
        nutritionStore.logFood(food: food)
        dismiss()
    }
    
}

struct AnimatedTabView: View {
    @Binding var currentTab: Int
    @Namespace var namespace
    
    var tabBarOptions: [String]// = ["All", "My Meals", "Recents"]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20.0) {
                ForEach(Array(zip(self.tabBarOptions.indices,
                                  self.tabBarOptions)),
                        id: \.0,
                        content: {
                    index, name in
                    AnimatedTabBarItem(currentTab: self.$currentTab,
                               namespace: namespace.self,
                               tabBarItemName: name,
                               tab: index)
                    
                })
            }
        }
        .frame(height: 40.0)
    }
}

struct AnimatedTabBarItem: View {
    @Binding var currentTab: Int
    let namespace: Namespace.ID
    
    var tabBarItemName: String
    var tab: Int
    
    var body: some View {
        Button {
            self.currentTab = tab
        } label: {
            VStack {
                Spacer()
                Text(tabBarItemName)
                    .foregroundStyle(currentTab == tab ? .primary : .secondary)
                if currentTab == tab {
                    Color.primary
                        .frame(height: 4)
                        .clipShape(Capsule())
                        .matchedGeometryEffect(id: "underline",
                                               in: namespace,
                                               properties: .frame)
                } else {
                    Color.clear.frame(height: 2)
                }
            }
            .animation(.bouncy(), value: self.currentTab)
        }
        .buttonStyle(.plain)
    }
}
