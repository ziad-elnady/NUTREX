//
//  NutritionDiaryScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import Charts
import SwiftUI

struct NutritionDiaryScreen: View {
    @Environment(\.selectedDate) private var selectedDate
    
    @EnvironmentObject private var userStore: UserStore
    @EnvironmentObject private var nutritionStore: NutritionDiaryStore
        
    @State private var alert: NXGenericAlert? = nil
    @State private var isShowingFoodSearch = false
    
    // TODO: For Testing
    private let foods: [Food] = Bundle.main.decode("Foods.json")
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                LazyVStack(pinnedViews: [.sectionHeaders]) {
                    Section{
                       
                    } header: {
                        HeaderView(date: selectedDate) {
//                            isShowingFoodSearch = true
                            logFood()
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        NutritionSection(dailyNutrition: nutritionStore.currentDiary)
                        GraphSectionView(dailyNtrition: nutritionStore.currentDiary)
                        
//                        FoodsSection(currentDiary: nutritionStore.currentDiary)
                    }
                    .padding(.horizontal)
                }
            }
            .scrollIndicators(.hidden)
            .background {
                Color(.nxBackground)
                    .ignoresSafeArea()
            }
        }
        .showAlert(alert: $alert)
        .fullScreenCover(isPresented: $isShowingFoodSearch) {
            FoodSearchScreen()
        }
        .onAppear {
            nutritionStore.getCurrentDiary(user: userStore.currentUser,
                                           date: selectedDate.wrappedValue)
        }
        .onChange(of: selectedDate.wrappedValue) { _, newValue in
            nutritionStore.getCurrentDiary(user: userStore.currentUser,
                                           date: newValue.onlyDate)
        }
    }
}

// MARK: - VIEWS -
extension NutritionDiaryScreen {
    
    struct NutritionSection: View {
        
        @EnvironmentObject private var userStore: UserStore
        @ObservedObject var dailyNutrition: DailyNutrition
        
        var body: some View {
            VStack {
                HStack(alignment: .top) {
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                .font(.title)
                                .foregroundStyle(.nxAccent)
                            
                            VStack(alignment: .leading) {
                                Text("Remaining")
                                    .captionFontStyle()
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                Text("\(dailyNutrition.remainingCalories(userGoal: userStore.currentUser.neededCalories).formatCalories()) kcal")
                                    .headlineFontStyle()
                            }
                        }
                        
                        HStack {
                            Group {
                                VStack(alignment: .leading) {
                                    Text("Goal")
                                        .captionFontStyle()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                    Text("\(userStore.currentUser.neededCalories.formatCalories()) kcal")
                                        .captionFontStyle()
                                        .fontWeight(.heavy)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("Last")
                                        .captionFontStyle()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                    Text("30 min")
                                        .captionFontStyle()
                                        .fontWeight(.heavy)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("status")
                                        .captionFontStyle()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                    Text("almost")
                                        .captionFontStyle()
                                        .fontWeight(.heavy)
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    Spacer()
                    
                    CircularProgressBar(progress: eatenPercentage() + 0.0001,
                                        progressColor: .nxAccent,
                                        text: "\(dailyNutrition.eatenCalories.formatCalories())\nkcal",
                                        description: "\(eatenPercentage().formatCalories())%")
                    .frame(width: 80, height: 80)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color(.nxCard))
            }
        }
        
        private func eatenPercentage() -> Double {
            let completionPercentage = dailyNutrition.eatenCalories / userStore.currentUser.neededCalories
            return (min(completionPercentage, 1.0) + 0.00001)
        }
    }
    
    
    struct GraphSectionView: View {
        @ObservedObject var dailyNtrition: DailyNutrition
        
        struct ChartModel: Identifiable {
            let id = UUID()
            
            let date: Date
            let calories: Double
        }
        
        var items:  [ChartModel] = [
            ChartModel(date: Date().addingTimeInterval(-9 * 24 * 3600), calories: 2400),
            ChartModel(date: Date().addingTimeInterval(-8 * 24 * 3600), calories: 2100),
            ChartModel(date: Date().addingTimeInterval(-7 * 24 * 3600), calories: 1900),
            ChartModel(date: Date().addingTimeInterval(-6 * 24 * 3600), calories: 2000),
            ChartModel(date: Date().addingTimeInterval(-5 * 24 * 3600), calories: 1800),
            ChartModel(date: Date().addingTimeInterval(-4 * 24 * 3600), calories: 2200),
            ChartModel(date: Date().addingTimeInterval(-3 * 24 * 3600), calories: 2400),
            ChartModel(date: Date().addingTimeInterval(-2 * 24 * 3600), calories: 2100),
            ChartModel(date: Date().addingTimeInterval(-1 * 24 * 3600), calories: 1900),
        ]
        
        var body: some View {
            VStack(alignment: .leading) {
                Text("Stats")
                    .sectionHeaderFontStyle()
                    .padding(.leading)
                
                VStack(alignment: .leading) {
                    HStack(spacing: 16.0) {
                        HStack {
                            RoundedRectangle(cornerRadius: 12.0)
                                .fill(Color(.nxAccent))
                                .frame(width: 16.0, height: 4.0)
                            
                            
                            Text("Today's Res")
                                .captionFontStyle()
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack {
                            RoundedRectangle(cornerRadius: 12.0)
                                .fill(.secondary)
                                .frame(width: 16.0, height: 4.0)
                            
                            
                            Text("Prev Res")
                                .captionFontStyle()
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 0.0) {
                            Text("Avg,")
                                .captionFontStyle()
                                .fontWeight(.heavy)
                                .foregroundStyle(.primary)
                            
                            Text("24MD")
                                .captionFontStyle()
                                .fontWeight(.heavy)
                                .foregroundStyle(Color(.nxAccent))
                        }
                    }
                    
                    Chart {
                        ForEach(items, id: \.id) { item in
                            
                            LineMark(
                                x: .value("Day", item.date, unit: .day),
                                y: .value("Calories", item.calories)
                            )
                            .foregroundStyle(Color(.nxAccent))
                            .interpolationMethod(.catmullRom)
                            
    //                        AreaMark(
    //                            x: .value("Day", item.date, unit: .day),
    //                            y: .value("Calories", item.calories)
    //                        )
    //                        .foregroundStyle( LinearGradient(
    //                            gradient: Gradient(colors: [
    //                                Color(.nxAccent).opacity(0.3), // Start with full opacity blue at the top
    //                                Color(.nxAccent).opacity(0.0)  // End with fully transparent blue at the bottom
    //                            ]),
    //                            startPoint: .top,
    //                            endPoint: .bottom
    //                        ))
    //                        .interpolationMethod(.catmullRom)
                        }
                    }
                    .chartYAxis(.hidden)
                    .padding(.top, 12.0)
                    .padding(.horizontal)
                    .frame(maxHeight: 250)
                }
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: 20.0)
                        .fill(Color(.nxCard))
                }
            }
            .padding(.top)
        }
    }
    
    
    struct FoodsSection: View {
        @EnvironmentObject var diaryStore: NutritionDiaryStore
        @ObservedObject var currentDiary: DailyNutrition
        
        var body: some View {
            VStack {
                ForEach(currentDiary.wrappedFoods, id: \.objectID) { food in
                    VStack(alignment: .leading) {
                        Text(food.wrappedName)
                            .bodyFontStyle()
                        
                        Text(food.wrappedNutritionalInfo.caloriesPerGram.formatCalories() + " kcal")
                            .captionFontStyle()
                            .foregroundStyle(.secondary)
                    }
                    .hSpacing(.leading)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 20.0)
                            .fill(Color(.nxCard))
                    }
                    .swipeActions(allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            diaryStore.removeFoodFromDiary(food: food)
                        } label: {
                            Text("Delete")
                        }
                    }
                    .onTapGesture {
                        diaryStore.removeFoodFromDiary(food: food)
                    }
                }
//                .onDelete(perform: removeFood)
                
            }
        }
        
//        private func removeFood(at offsets: IndexSet) {
//            diaryStore.removeFoodFromDiary(food: offsets)
//        }
    }
}


struct CircularProgressBar: View {
    let progress: Double
    let progressColor: Color
    let text: String
    let description: String?
    
    init(progress: Double, progressColor: Color, text: String, description: String? = nil) {
        self.progress = progress
        self.progressColor = progressColor
        self.text = text
        self.description = description
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: lineWidth(for: geometry.size), lineCap: .round, lineJoin: .round))
                    .foregroundColor(.nxBackground)
                    .rotationEffect(Angle(degrees: -90))
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(style: StrokeStyle(lineWidth: lineWidth(for: geometry.size), lineCap: .round, lineJoin: .round))
                    .foregroundColor(progressColor)
                    .rotationEffect(Angle(degrees: -90))
                
                VStack(spacing: 4.0) {
                    Text(text)
                        .font(.customFont(font: .audiowide, size: .caption, relativeTo: .caption))
                        .multilineTextAlignment(.center)
                    
                    if let desc = description {
                        Text(desc)
                            .font(.customFont(font: .audiowide, size: .caption2, relativeTo: .caption2))
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
        }
    }

    func lineWidth(for size: CGSize) -> CGFloat {
        let minLength = min(size.width, size.height)
        return minLength * 0.08
    }
}

// MARK: - ACTIONS -
extension NutritionDiaryScreen {
    
    private func logFood() {
//        nutritionStore.logFood(foods: foods)
        isShowingFoodSearch = true
    }
    
}



struct MacroView: View {
    let title: String
    let progress: Double
    let maxValue: Double
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 4.0) {
                Text(title)
                    .font(.customFont(font: .audiowide, size: .caption2, relativeTo: .caption2))
                
                Capsule()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 6.0)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.tint)
                            .frame(maxWidth: progressWidth(for: geometry.size.width))
                            .frame(height: 6.0)
                    }
                
                Text("\(Int(progress * maxValue)) / \(maxValue.formatted(.number)) g")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: geometry.size.width)
        }
        
    }
    
    func progressWidth(for totalWidth: CGFloat) -> CGFloat {
        let maxWidth = totalWidth - 10
        return min(maxWidth * CGFloat(progress), maxWidth)
    }
}

#Preview {
    NutritionDiaryScreen()
        .environmentObject(UserStore())
        .environmentObject(NutritionDiaryStore())
}


