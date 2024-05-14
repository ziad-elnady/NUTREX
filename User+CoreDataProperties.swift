//
//  User+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 21/03/2024.
//
//

import FirebaseFirestore
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

    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.bodyType        == rhs.bodyType &&
        lhs.dateOfBirth     == rhs.dateOfBirth &&
        lhs.gender          == rhs.gender &&
        lhs.goal            == rhs.goal &&
        lhs.height          == rhs.height &&
        lhs.weight          == rhs.weight &&
        lhs.username        == rhs.username &&
        lhs.uid             == rhs.uid &&
        lhs.activityLevel   == rhs.activityLevel &&
        lhs.email           == rhs.email
    }
    
    static func filteredUsersForID(_ uid: String) -> NSFetchRequest<User> {
        let request = User.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "uid == %@", uid)
        return request
    }

    static var empty: User {
        let newUser = User(context: CoreDataController.shared.viewContext)
        return newUser
    }

    public var isNotEmpty: Bool {
        return !(uid == nil || username == nil)
    }
    
    public var isEmpty: Bool {
        return uid == nil || username == nil
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
        updatedAt ?? Date.now
    }

    
    var wrappedRoutineMeals: [RoutineMeal] {
        let set = mealRoutines as? Set<RoutineMeal> ?? []
        
        return set.sorted {
            $0.index < $1.index
        }
    }
    
    var isProfileCompleted: Bool {
        return bodyType != nil &&
        dateOfBirth != nil &&
        gender != nil &&
        goal != nil &&
        height != 0.0 &&
        weight != 0.0 &&
        activityLevel != nil
    }

    var neededCalories: Double {
        HealthCalculator.shared.calculateCaloricGoal(user: self)
    }

    var age: Int {
        dateOfBirth?.age() ?? Date.distantPast.age()
    }
    
    func migrate(toUser user: User) {
        self.bodyType        = user.bodyType
        self.dateOfBirth     = user.dateOfBirth
        self.gender          = user.gender
        self.goal            = user.goal
        self.height          = user.height
        self.weight          = user.weight
        self.username        = user.username
        self.uid             = user.uid
        self.activityLevel   = user.activityLevel
        self.email           = user.email
        self.createdAt       = user.createdAt
        self.updatedAt       = Timestamp().dateValue()
    }
    
    func completeProfile(withConfig config: ProfileSetupScreen.UserProfileSetupConfig) {
        self.bodyType        = config.bodyType.rawValue
        self.dateOfBirth     = config.dateOfBirth
        self.gender          = config.selectedGender.rawValue
        self.goal            = config.selectedGoal.rawValue
        self.height          = config.heightValue
        self.weight          = config.weightValue
        self.activityLevel   = config.activityLevel.rawValue
        self.createdAt       = Timestamp().dateValue()
        self.updatedAt       = Timestamp().dateValue()
        
        // Setting default meals
        for routineMeal in RoutineMeal.defaultMeals() {
            self.addToMealRoutines(routineMeal)
        }
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
