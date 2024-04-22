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
    
    static func userDiariesForDate(_ uid: String, date: Date) -> NSFetchRequest<Diary> {
        let request: NSFetchRequest<Diary> = Diary.fetchRequest()
        request.predicate = NSPredicate(format: "user.uid == %@ AND date == %@", uid, date.onlyDate as CVarArg)
        return request
    }

    var wrappedDate: Date {
        date?.onlyDate ?? Date.now.onlyDate
    }
    
    public var wrappedDailyNutritionList: [DailyNutrition] {
        let set = dailyNutrition as? Set<DailyNutrition> ?? []
        
        return set.sorted {
            $0.wrappedDate < $1.wrappedDate
        }
    }
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
