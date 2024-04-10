//
//  DailyNutrition+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension DailyNutrition {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyNutrition> {
        return NSFetchRequest<DailyNutrition>(entityName: "DailyNutrition")
    }

    @NSManaged public var date: Date?
    @NSManaged public var diary: Diary?
    @NSManaged public var foods: NSSet?
    
    static func userDiariesForDate(_ user: User, date: Date) -> NSFetchRequest<DailyNutrition> {
        let request = DailyNutrition.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "user == %@ AND date == %@", argumentArray: [user, date])
        return request
    }
    
    static var empty: DailyNutrition {
        let newDiary = DailyNutrition(context: CoreDataController.shared.viewContext)
        return newDiary
    }
    
    public func remainingCalories(userGoal: Double) ->  Double {
        let foodsCalories = wrappedFoods.map { $0.calculatedNutritionalInfo.calories }
        return userGoal - eatenCalories
    }

    var wrappedDate: Date {
        date?.onlyDate ?? Date.now.onlyDate
    }
    
    public var wrappedFoods: [Food] {
        let set = foods as? Set<Food> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
    public var eatenCalories: Double {
        let foodsCalories = wrappedFoods.map { $0.calculatedNutritionalInfo.calories }
        return Double(foodsCalories.reduce(0, +))
    }
    
    public var totalProteinEaten: Double {
        let foodsProteins = wrappedFoods.map { $0.calculatedNutritionalInfo.protein }
        return Double(foodsProteins.reduce(0, +))
    }
    
    public var totalCarbohydratesEaten: Double {
        let foodsCarbohydrates = wrappedFoods.map { $0.calculatedNutritionalInfo.carbs }
        return Double(foodsCarbohydrates.reduce(0, +))
    }
    
    public var totalFatsEaten: Double {
        let foodsFats = wrappedFoods.map { $0.calculatedNutritionalInfo.fat }
        return Double(foodsFats.reduce(0, +))
    }
    
}

// MARK: Generated accessors for foods
extension DailyNutrition {

    @objc(addFoodsObject:)
    @NSManaged public func addToFoods(_ value: Food)

    @objc(removeFoodsObject:)
    @NSManaged public func removeFromFoods(_ value: Food)

    @objc(addFoods:)
    @NSManaged public func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged public func removeFromFoods(_ values: NSSet)

}

extension DailyNutrition : Identifiable {

}
