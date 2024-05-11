//
//  RoutineMeal+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension RoutineMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineMeal> {
        return NSFetchRequest<RoutineMeal>(entityName: "RoutineMeal")
    }

    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var user: User?
    
    static func userRoutineMeals(_ uid: String) -> NSFetchRequest<RoutineMeal> {
        let request: NSFetchRequest<RoutineMeal> = RoutineMeal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "index", ascending: true)]
        request.predicate = NSPredicate(format: "user.uid == %@", uid)
        return request
    }

    var wrappedName: String {
        name ?? "No Routine Meal Name"
    }
    
    static func defaultMeals() -> [RoutineMeal] {
        let context = CoreDataController.shared.viewContext
        let defaultMealNames = ["Breakfast", "Lunch", "Dinner", "Snacks"]
        
        var routineMeals: [RoutineMeal] = []
        
        for mealName in defaultMealNames {
            var index = 0
            
            let meal = RoutineMeal(context: context)
            meal.name = mealName
            meal.index = Int16(index)
            
            routineMeals.append(meal)
            index += 1
        }
        
        return routineMeals
    }
    
}

extension RoutineMeal : Identifiable {

}
