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
    
    func removeItems(at offsets: IndexSet) {
        offsets.forEach { index in
            dataController.viewContext.delete(routineMeals[index])
        }
        routineMeals.remove(atOffsets: offsets)
        saveContext()
    }
    
    private func saveContext() {
        dataController.saveContext()
    }
    
}
