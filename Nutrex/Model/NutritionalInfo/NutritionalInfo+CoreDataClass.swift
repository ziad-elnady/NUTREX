//
//  NutritionalInfo+CoreDataClass.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData

@objc(NutritionalInfo)
public class NutritionalInfo: NSManagedObject, Codable {
    enum CodingKeys: CodingKey {
        case caloriesPerGram, carbsPerGram, fatPerGram, proteinPerGram
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.caloriesPerGram = try container.decode(Double.self, forKey: .caloriesPerGram)
        self.carbsPerGram = try container.decode(Double.self, forKey: .carbsPerGram)
        self.fatPerGram = try container.decode(Double.self, forKey: .fatPerGram)
        self.proteinPerGram = try container.decode(Double.self, forKey: .proteinPerGram)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(caloriesPerGram, forKey: .caloriesPerGram)
        try container.encode(carbsPerGram, forKey: .carbsPerGram)
        try container.encode(fatPerGram, forKey: .fatPerGram)
        try container.encode(proteinPerGram, forKey: .proteinPerGram)
    }
}
