//
//  RoutineMealStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 01/05/2024.
//

import Foundation

@MainActor
class RoutineMealStore: ObservableObject {
    private let dataController = CoreDataController.shared
    
    @Published var currentMeal: String? = nil
    
    @Published var routineMeals: [RoutineMeal] = RoutineMeal.defaultMeals()
    @Published var filterdFoodsForRoutineMeal: [Food] = []
    
    func fetchRoutineMeals(forUid uid: String) {
        let routineMealsRequest = RoutineMeal.userRoutineMeals(uid)
        
        guard let fetchedRoutineMeals = try? dataController.viewContext.fetch(routineMealsRequest) else { return }
        
        if fetchedRoutineMeals.isEmpty { return }
                
        routineMeals = fetchedRoutineMeals
    }

    func createNewRoutineMeal(name: String) {
        let itemExist = routineMeals.contains(where: { $0.name == name })
        if itemExist { return }
        
        let newRoutineMeal = RoutineMeal(context: dataController.viewContext)
        newRoutineMeal.name = name
        newRoutineMeal.index = Int16(routineMeals.count)
        
        routineMeals.append(newRoutineMeal)
        saveContext()
    }
    
    func moveRoutineMeal(from source: IndexSet, to destination: Int) {
        routineMeals.move(fromOffsets: source, toOffset: destination)
        
        for (index, routineMeal) in routineMeals.enumerated() {
            routineMeal.index = Int16(index)
        }
        
        saveContext()
    }
    
    func removeRotineMeal(at offsets: IndexSet) {
        offsets.forEach { index in
            dataController.viewContext.delete(routineMeals[index])
        }
        routineMeals.remove(atOffsets: offsets)
        saveContext()
    }
    
    func deleteFoodFromRotineMeal(diary: DailyNutrition, at offsets: IndexSet) {
        offsets.forEach { index in
            let deletedFood = filterdFoodsForRoutineMeal[index]
            diary.removeFromFoods(deletedFood)
            filterdFoodsForRoutineMeal.remove(atOffsets: offsets)
            Toast.shared.present(title: "Successfully removed \(deletedFood) from your diary", symbol: "checkmark.circle", tint: .nxAccent)
            saveContext()
        }
    }
    
    func filterFoodsForRoutineMeal(diary: DailyNutrition, mealName: String) {
        filterdFoodsForRoutineMeal = diary.wrappedFoods.filter { $0.wrappedMealName == mealName }
    }
    
    func calculateMealNutritions() -> (calories: Double, protein: Double, carbs: Double, fat: Double) {
        var total: (calories: Double, protein: Double, carbs: Double, fat: Double) = (0.0, 0.0, 0.0, 0.0)
        
        filterdFoodsForRoutineMeal.forEach {
            let foodNutritions = $0.calculatedNutritionalInfo
            total.calories += foodNutritions.calories
            total.protein += foodNutritions.protein
            total.carbs += foodNutritions.carbs
            total.fat += foodNutritions.fat
        }
        
        return total
    }
    
    private func saveContext() {
        dataController.saveContext()
    }
    
}
