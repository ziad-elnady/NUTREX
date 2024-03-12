//
//  Food+CoreDataClass.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData

@objc(Food)
public class Food: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case name, serving, measurementUnits, nutritionalInfo
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.serving = try container.decode(Double.self, forKey: .serving)
        self.measurementUnits = try container.decode(Set<MeasurementUnit>.self, forKey: .measurementUnits) as NSSet
        self.nutritionalInfo = try container.decode(NutritionalInfo.self, forKey: .nutritionalInfo)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(serving, forKey: .serving)
        try container.encode(measurementUnits as! Set<MeasurementUnit>, forKey: .measurementUnits)
        try container.encode(nutritionalInfo, forKey: .nutritionalInfo)
      }
}
