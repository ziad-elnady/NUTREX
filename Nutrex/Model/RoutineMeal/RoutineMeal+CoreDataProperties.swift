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

    var wrappedName: String {
        name ?? "No Routine Meal Name"
    }
    
    static func defaultMeals() -> [RoutineMeal] {
        let context = CoreDataController.shared.viewContext
        
        let meal1 = RoutineMeal(context: context)
        meal1.name = "Breakfast"
        meal1.index = 0
        
        let meal2 = RoutineMeal(context: context)
        meal2.name = "Lunch"
        meal2.index = 1
        
        let meal3 = RoutineMeal(context: context)
        meal3.name = "Dinner"
        meal3.index = 2
        
        return [meal1, meal2, meal3]
    }
    
}

extension RoutineMeal : Identifiable {

}
