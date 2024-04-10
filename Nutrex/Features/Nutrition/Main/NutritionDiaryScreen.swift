//
//  NutritionDiaryScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct NutritionDiaryScreen: View {
    @Environment(\.managedObjectContext) private var context
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
                    
                    VStack {
                        NutritionSection(currentUser: userStore.currentUser,
                                         diary: nutritionStore.currentDiary)
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
    }
}

// MARK: - VIEWS -
extension NutritionDiaryScreen {
    
    struct NutritionSection: View {
        
        let currentUser: User
        let diary: DailyNutrition
        
        var body: some View {
            VStack {
                HStack(alignment: .top) {
                    
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "takeoutbag.and.cup.and.straw.fill")
                                .font(.title)
                                .foregroundStyle(.nxAccent)
                            
                            VStack(alignment: .leading) {
                                Text("Goal")
                                    .captionFontStyle()
                                    .fontWeight(.semibold)
                                    .foregroundStyle(.secondary)
                                Text("\(currentUser.neededCalories.formatCalories()) kcal")
                                    .headlineFontStyle()
                            }
                        }
                        
                        HStack {
                            Group {
                                VStack(alignment: .leading) {
                                    Text("Remaining")
                                        .captionFontStyle()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                    Text("\(diary.remainingCalories(userGoal: currentUser.neededCalories).formatCalories()) kcal")
                                        .captionFontStyle()
                                        .fontWeight(.heavy)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("last")
                                        .captionFontStyle()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                    Text("30 min")
                                        .captionFontStyle()
                                        .fontWeight(.heavy)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("any")
                                        .captionFontStyle()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.secondary)
                                    Text("something")
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
                                        text: "\(diary.eatenCalories.formatCalories()) kcal",
                                        description: "\(eatenPercentage().formatted())%")
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
            let completionPercentage = (diary.eatenCalories / currentUser.neededCalories) * 100
            return min(completionPercentage, 100)
        }
    }
}


// MARK: - ACTIONS -
extension NutritionDiaryScreen {
    private func logFood() {
        var newFood = Food(context: context)
        newFood = foods.randomElement() ?? Food(context: context)
        
        nutritionStore.currentDiary.addToFoods(newFood)
        
        try? context.save()
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
                        .font(.customFont(font: .audiowide, size: .body, relativeTo: .body))
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
