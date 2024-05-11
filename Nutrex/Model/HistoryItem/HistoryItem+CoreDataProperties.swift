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
    
    static func historyItemsForSearchTerm(term: String) -> NSFetchRequest<HistoryItem> {
        let request: NSFetchRequest<HistoryItem> = HistoryItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.predicate = NSPredicate(format: "text == %@", term)
        return request
    }
    
    public var wrappedText: String {
        text ?? "No Name"
    }
    
    public var wrappedFood: Food {
        let context = CoreDataController.shared.viewContext
        return food ?? Food(context: context)
    }
    
    public var wrappedUnit: String {
        unit ?? "No Unit"
    }
    
    static func foodExists(_ food: Food) -> Bool {
        let context = CoreDataController.shared.viewContext
        let request = self.fetchRequest()
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "serving == %@ AND unit == %@", NSNumber(value: food.serving), food.wrappedUnitName)
        return ((try? context.fetch(request)) ?? []).count > 0
    }

}

extension HistoryItem : Identifiable {

}
