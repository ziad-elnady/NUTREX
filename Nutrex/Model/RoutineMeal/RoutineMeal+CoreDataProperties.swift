//
//  RoutineMeal+CoreDataProperties.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData


extension RoutineMeal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoutineMeal> {
        return NSFetchRequest<RoutineMeal>(entityName: "RoutineMeal")
    }

    @NSManaged public var index: Int16
    @NSManaged public var name: String?
    @NSManaged public var user: User?

}

extension RoutineMeal : Identifiable {

}
