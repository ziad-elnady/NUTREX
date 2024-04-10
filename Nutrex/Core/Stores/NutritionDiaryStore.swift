//
//  NutritionDiaryStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 09/04/2024.
//

import CoreData
import Foundation

class NutritionDiaryStore: ObservableObject {
    private let context = CoreDataController.shared.viewContext
    
    var currentDiary: DailyNutrition = DailyNutrition.empty
    
    func getCurrentDiary(user: User, date: Date) {
        let diariesRequest = Diary.userDiariesForDate(user, date: date.onlyDate)
        
        guard let fetchedDiaries = try? context.fetch(diariesRequest) else { return }
        
        if let fetchedDiary = fetchedDiaries.first {
            
            if let currentNutritionDiary = fetchedDiary.wrappedDailyNutritionList.first {
                currentDiary = currentNutritionDiary
            } else {
                let newNutritionDiary = DailyNutrition(context: context)
                newNutritionDiary.date = date
            }
            
        }
    }
}
