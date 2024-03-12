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
