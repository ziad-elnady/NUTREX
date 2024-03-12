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
