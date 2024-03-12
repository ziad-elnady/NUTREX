//
//  Exercise+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension Exercise {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Exercise> {
        return NSFetchRequest<Exercise>(entityName: "Exercise")
    }

    @NSManaged public var burnedCal: Double
    @NSManaged public var category: String?
    @NSManaged public var difficulty: String?
    @NSManaged public var equipment: String?
    @NSManaged public var estimatedTime: Date?
    @NSManaged public var info: String?
    @NSManaged public var instructions: String?
    @NSManaged public var muscle: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: String?
    @NSManaged public var type: String?
    @NSManaged public var video: String?
    @NSManaged public var workoutPlan: WorkoutPlan?
    @NSManaged public var workoutRoutine: DailyWorkout?

}

extension Exercise : Identifiable {

}
