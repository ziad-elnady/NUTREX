//
//  User+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var bodyType: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var gender: String?
    @NSManaged public var goal: String?
    @NSManaged public var height: Double
    @NSManaged public var username: String?
    @NSManaged public var weight: Double
    @NSManaged public var uid: String?
    @NSManaged public var email: String?
    @NSManaged public var diaries: NSSet?
    @NSManaged public var mealRoutines: NSSet?

}

// MARK: Generated accessors for diaries
extension User {

    @objc(addDiariesObject:)
    @NSManaged public func addToDiaries(_ value: Diary)

    @objc(removeDiariesObject:)
    @NSManaged public func removeFromDiaries(_ value: Diary)

    @objc(addDiaries:)
    @NSManaged public func addToDiaries(_ values: NSSet)

    @objc(removeDiaries:)
    @NSManaged public func removeFromDiaries(_ values: NSSet)

}

// MARK: Generated accessors for mealRoutines
extension User {

    @objc(addMealRoutinesObject:)
    @NSManaged public func addToMealRoutines(_ value: RoutineMeal)

    @objc(removeMealRoutinesObject:)
    @NSManaged public func removeFromMealRoutines(_ value: RoutineMeal)

    @objc(addMealRoutines:)
    @NSManaged public func addToMealRoutines(_ values: NSSet)

    @objc(removeMealRoutines:)
    @NSManaged public func removeFromMealRoutines(_ values: NSSet)

}

extension User : Identifiable {

}
