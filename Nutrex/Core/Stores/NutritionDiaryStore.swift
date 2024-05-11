//
//  NutritionDiaryStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 09/04/2024.
//

import CoreData
import Foundation

@MainActor
class NutritionDiaryStore: ObservableObject {
    private let context = CoreDataController.shared.viewContext
    
    @Published var currentDiary: DailyNutrition = DailyNutrition.empty
    @Published var historyItems: [HistoryItem]  = []
    
    // TODO: For Testing
    static let foods: [Food] = Bundle.main.decode("Foods.json")
    
    func getCurrentDiary(user: User, date: Date) {
        let diariesRequest = Diary.userDiariesForDate(user.wrappedUid, date: date)
        
        guard let fetchedDiaries = try? context.fetch(diariesRequest) else { return }
                
        if let fetchedDiary = fetchedDiaries.first {
            
            if let currentNutritionDiary = fetchedDiary.wrappedDailyNutritionList.first {
                currentDiary = currentNutritionDiary
            }
            
        } else {
            createNewDiary(withUser: user, forDate: date)
        }
        
    }
    
    func fetchHistoryItems(term: String) {
        let fetchRequest = HistoryItem.historyItemsForSearchTerm(term: term)
        guard let fetchedHistoryItems = try? context.fetch(fetchRequest) else { return }
        historyItems = fetchedHistoryItems
    }
    
    func logFood(food: Food,forRoutineMeal meal: String?) {
        guard meal != nil else { return }
        food.meal = meal
        
        food.loggedAt = Date.now
        food.createHistoryItemIfNeeded()
               
        //TODO: Fix 0
        currentDiary.addToFoods(food)
        
        print(food.meal)
                
        CoreDataController.shared.saveContext()
        Toast.shared.present(title: "Successfully logged \(food.wrappedName) to your diary", symbol: "checkmark.circle.fill", tint: .nxAccent)
    }
    
    func removeFoodFromDiary(food: Food) {
        //        for index in offsets {
        //            let food = currentDiary.wrappedFoods[index]
        currentDiary.removeFromFoods(food)
        context.delete(food)
        CoreDataController.shared.saveContext()
        //        }
    }
    
    func filterFoodsForMeal(mealName: String) -> [Food] {
        let filterdFoods = currentDiary.wrappedFoods.filter { $0.wrappedMealName == mealName }
        return filterdFoods
    }
    
    private func createNewDiary(withUser user: User, forDate date: Date) {
        let newDiary = Diary(context: context)
        newDiary.date = date.onlyDate
        newDiary.user = user
        
        createNewNutritionDiary(forDiary: newDiary, withDate: date.onlyDate)
    }
    
    private func createNewNutritionDiary(forDiary diary: Diary, withDate date: Date) {
        let newNutritionDiary = DailyNutrition(context: context)
        newNutritionDiary.date = date.onlyDate
        newNutritionDiary.diary = diary
        
        diary.addToDailyNutrition(newNutritionDiary)
        currentDiary = newNutritionDiary
    }
}
