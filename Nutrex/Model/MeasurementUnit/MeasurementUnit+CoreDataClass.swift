//
//  MeasurementUnit+CoreDataClass.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData

@objc(MeasurementUnit)
public class MeasurementUnit: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case conversionToGrams, unitName
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.conversionToGrams = try container.decode(Double.self, forKey: .conversionToGrams)
        self.unitName = try container.decode(String.self, forKey: .unitName)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(conversionToGrams, forKey: .conversionToGrams)
        try container.encode(unitName, forKey: .unitName)
    }
}
