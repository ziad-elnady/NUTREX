//
//  NutritionalInfo+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension NutritionalInfo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NutritionalInfo> {
        return NSFetchRequest<NutritionalInfo>(entityName: "NutritionalInfo")
    }

    @NSManaged public var caloriesPerGram: Double
    @NSManaged public var carbsPerGram: Double
    @NSManaged public var fatPerGram: Double
    @NSManaged public var proteinPerGram: Double
    @NSManaged public var food: Food?

}

extension NutritionalInfo : Identifiable {

}
