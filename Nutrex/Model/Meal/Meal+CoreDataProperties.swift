//
//  Meal+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension Meal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Meal> {
        return NSFetchRequest<Meal>(entityName: "Meal")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var instructions: String?
    @NSManaged public var name: String?
    @NSManaged public var foods: NSSet?
    @NSManaged public var historyItem: HistoryItem?

    public var wrappedName: String {
        name ?? "No Meal Name"
    }
    
    public var wrappedInstructions: String {
        instructions ?? "No Instrtuctions"
    }
    
    public var wrappedFoods: [Food] {
        let set = foods as? Set<Food> ?? []
        
        return set.sorted {
            $0.wrappedName < $1.wrappedName
        }
    }
    
}

// MARK: Generated accessors for foods
extension Meal {

    @objc(addFoodsObject:)
    @NSManaged public func addToFoods(_ value: Food)

    @objc(removeFoodsObject:)
    @NSManaged public func removeFromFoods(_ value: Food)

    @objc(addFoods:)
    @NSManaged public func addToFoods(_ values: NSSet)

    @objc(removeFoods:)
    @NSManaged public func removeFromFoods(_ values: NSSet)

}

extension Meal : Identifiable {

}
