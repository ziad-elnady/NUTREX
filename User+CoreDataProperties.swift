//
//  User+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 21/03/2024.
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

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var bodyType: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var email: String?
    @NSManaged public var gender: String?
    @NSManaged public var goal: String?
    @NSManaged public var height: Double
    @NSManaged public var uid: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var username: String?
    @NSManaged public var weight: Double
    @NSManaged public var activityLevel: String?
    @NSManaged public var diaries: NSSet?
    @NSManaged public var mealRoutines: NSSet?

    static func filteredUsersForID(_ uid: String) -> NSFetchRequest<User> {
        let request = User.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "uid == %@", uid)
        return request
    }

    static var empty: User {
        let newUser = User(context: CoreDataController.shared.container.viewContext)
        return newUser
    }

    public var isNotEmpty: Bool {
        return !(uid == nil && username == nil)
    }

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
    
    var wrappedCreatedAt: Date {
        createdAt ?? Date.now
    }
    
    var wrappedUpdatedAt: Date {
        createdAt ?? Date.now
    }

    var isProfileCompleted: Bool {
        return bodyType != nil &&
        dateOfBirth != nil &&
        gender != nil &&
        goal != nil &&
        height != 0.0 &&
        weight != 0.0 &&
        username != nil &&
        uid != nil &&
        activityLevel != nil &&
        email != nil
    }

    var neededCalories: Double {
        HealthCalculator.shared.calculateCaloricGoal(user: self)
    }

    var age: Int {
        dateOfBirth?.age() ?? Date.distantPast.age()
    }
    
    func migrate(withUser user: User) {
        bodyType        = user.bodyType
        dateOfBirth     = user.dateOfBirth
        gender          = user.gender
        goal            = user.goal
        height          = user.height
        weight          = user.weight
        username        = user.username
        uid             = user.uid
        activityLevel   = user.activityLevel
        email           = user.email
        updatedAt       = Date.now
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
