//
//  Food+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension Food {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Food> {
        return NSFetchRequest<Food>(entityName: "Food")
    }

    @NSManaged public var meal: String?
    @NSManaged public var name: String?
    @NSManaged public var serving: Double
    @NSManaged public var unit: Int16
    @NSManaged public var customMeal: Meal?
    @NSManaged public var historyItem: HistoryItem?
    @NSManaged public var measurementUnits: NSSet?
    @NSManaged public var nutrition: DailyNutrition?
    @NSManaged public var nutritionalInfo: NutritionalInfo?
    
    static var example: Food {
        NutritionDiaryStore.foods[5]
    }

    var measurmentUnitsList: [MeasurementUnit] {
        let set = measurementUnits as? Set<MeasurementUnit> ?? []
        
        return set.sorted {
            $0.wrappedUnitName < $1.wrappedUnitName
        }
    }
    
    var wrappedNutritionalInfo: (caloriesPerGram: Double, proteinPerGram: Double, carbsPerGram: Double, fatPerGram: Double) {
        let caloriesPerGram = nutritionalInfo?.caloriesPerGram ?? 0.0
        let proteinPerGram = nutritionalInfo?.proteinPerGram ?? 0.0
        let carbsPerGram = nutritionalInfo?.carbsPerGram ?? 0.0
        let fatPerGram = nutritionalInfo?.fatPerGram ?? 0.0
        
        return (caloriesPerGram, proteinPerGram, carbsPerGram, fatPerGram)
    }
    
    var wrappedName: String {
        name ?? "No Food Name"
    }
    
    var wrappedMealName: String {
        meal ?? "No Meal Name"
    }
    
    var wrappedUnit: Int {
        Int(unit)
    }
    
    var wrappedUnitName: String {
        measurmentUnitsList[Int(unit)].unitName ?? "No Unit"
    }
    
    var calculatedNutritionalInfo: (calories: Double, protein: Double, carbs: Double, fat: Double) {
        NutritionCalculator.shared.calculateNutrition(food: self, unitIndex: Int(unit), servings: serving)
    }
    
    func calculateMacroPercentages() -> (proteinPercentage: Double, carbPercentage: Double, fatPercentage: Double) {
        let nutritions = calculatedNutritionalInfo
        let calories = nutritions.calories
        
        guard calories > 0 else {
            return (1.0, 1.0, 1.0)
        }
        
        // Calculate percentages
        let proteinPercentage = (nutritions.protein / calories) * 100
        let carbPercentage = (nutritions.carbs / calories) * 100
        let fatPercentage = (nutritions.fat / calories) * 100
        
        return (proteinPercentage, carbPercentage, fatPercentage)
    }
    
}

// MARK: Generated accessors for measurementUnits
extension Food {

    @objc(addMeasurementUnitsObject:)
    @NSManaged public func addToMeasurementUnits(_ value: MeasurementUnit)

    @objc(removeMeasurementUnitsObject:)
    @NSManaged public func removeFromMeasurementUnits(_ value: MeasurementUnit)

    @objc(addMeasurementUnits:)
    @NSManaged public func addToMeasurementUnits(_ values: NSSet)

    @objc(removeMeasurementUnits:)
    @NSManaged public func removeFromMeasurementUnits(_ values: NSSet)

}

extension Food : Identifiable {

}
