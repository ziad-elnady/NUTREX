//
//  DailyWorkout+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension DailyWorkout {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyWorkout> {
        return NSFetchRequest<DailyWorkout>(entityName: "DailyWorkout")
    }

    @NSManaged public var date: Date?
    @NSManaged public var diary: Diary?
    @NSManaged public var exercise: NSSet?

}

// MARK: Generated accessors for exercise
extension DailyWorkout {

    @objc(addExerciseObject:)
    @NSManaged public func addToExercise(_ value: Exercise)

    @objc(removeExerciseObject:)
    @NSManaged public func removeFromExercise(_ value: Exercise)

    @objc(addExercise:)
    @NSManaged public func addToExercise(_ values: NSSet)

    @objc(removeExercise:)
    @NSManaged public func removeFromExercise(_ values: NSSet)

}

extension DailyWorkout : Identifiable {

}
