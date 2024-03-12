//
//  HistoryItem+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension HistoryItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryItem> {
        return NSFetchRequest<HistoryItem>(entityName: "HistoryItem")
    }

    @NSManaged public var createdAt: Date?
    @NSManaged public var repetition: Int16
    @NSManaged public var serving: Double
    @NSManaged public var text: String?
    @NSManaged public var unit: String?
    @NSManaged public var food: Food?
    @NSManaged public var meal: Meal?

}

extension HistoryItem : Identifiable {

}
