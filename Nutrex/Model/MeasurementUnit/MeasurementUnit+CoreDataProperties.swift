//
//  MeasurementUnit+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension MeasurementUnit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MeasurementUnit> {
        return NSFetchRequest<MeasurementUnit>(entityName: "MeasurementUnit")
    }

    @NSManaged public var conversionToGrams: Double
    @NSManaged public var unitName: String?
    @NSManaged public var food: Food?

}

extension MeasurementUnit : Identifiable {

}
