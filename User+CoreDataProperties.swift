//
//  User+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData

enum Goal: String, CaseIterable, Codable {
    case maintain = "Maintain"
    case weightLoss = "Weight Loss"
    case weightGain = "Weight Gain"
}

enum Gender: String, CaseIterable, Codable {
    case male = "Male"
    case female = "Female"
}

enum BodyType: String, CaseIterable, Codable {
    case ectomorph = "Ectomorph"
    case endomorph = "Endomorph"
    case mesomorph = "Mesomorph"
}

enum ActivityLevel: String, CaseIterable, Codable {
    case sedentary = "Sedentary"
    case lightlyActive = "Lightly Active"
    case moderatelyActive = "Moderately Active"
    case veryActive = "Very Active"
}

enum DefaultUserProfileValues: Double {
    case height = 175.0
    case weight = 70.0
}

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

    var wrappedUid: String {
        uid ?? "No Uid"
    }
    
    var wrappedName: String {
        username ?? "No username"
    }
    
    var wrappedEmail: String {
        email ?? "No email"
    }

    var wrappedGoal: String {
        goal ?? "No Goal"
    }
    
    var wrappedGender: String {
        gender ?? "No Gender"
    }
    
    var isProfileCompleted: Bool {
        return bodyType != nil &&
        dateOfBirth != nil &&
        gender != nil &&
        goal != nil &&
        height != DefaultUserProfileValues.height.rawValue &&
        weight != DefaultUserProfileValues.weight.rawValue &&
        username != nil &&
        uid != nil &&
        email != nil
    }
    
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
