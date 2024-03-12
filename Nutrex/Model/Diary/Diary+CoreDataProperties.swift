//
//  Diary+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension Diary {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diary> {
        return NSFetchRequest<Diary>(entityName: "Diary")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dailyNutrition: NSSet?
    @NSManaged public var dailyWorkout: NSSet?
    @NSManaged public var user: User?

}

// MARK: Generated accessors for dailyNutrition
extension Diary {

    @objc(addDailyNutritionObject:)
    @NSManaged public func addToDailyNutrition(_ value: DailyNutrition)

    @objc(removeDailyNutritionObject:)
    @NSManaged public func removeFromDailyNutrition(_ value: DailyNutrition)

    @objc(addDailyNutrition:)
    @NSManaged public func addToDailyNutrition(_ values: NSSet)

    @objc(removeDailyNutrition:)
    @NSManaged public func removeFromDailyNutrition(_ values: NSSet)

}

// MARK: Generated accessors for dailyWorkout
extension Diary {

    @objc(addDailyWorkoutObject:)
    @NSManaged public func addToDailyWorkout(_ value: DailyWorkout)

    @objc(removeDailyWorkoutObject:)
    @NSManaged public func removeFromDailyWorkout(_ value: DailyWorkout)

    @objc(addDailyWorkout:)
    @NSManaged public func addToDailyWorkout(_ values: NSSet)

    @objc(removeDailyWorkout:)
    @NSManaged public func removeFromDailyWorkout(_ values: NSSet)

}

extension Diary : Identifiable {

}
