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
    
    func logFood(food: Food) {
        currentDiary.addToFoods(food)
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
