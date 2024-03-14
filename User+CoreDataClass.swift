//
//  User+CoreDataClass.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case bodyType
        case dateOfBirth
        case gender
        case goal
        case height
        case username
        case weight
        case uid
        case email
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        
        self.init(context: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.bodyType = try container.decodeIfPresent(String.self, forKey: .bodyType)
        self.dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        self.gender = try container.decodeIfPresent(String.self, forKey: .gender)
        self.goal = try container.decodeIfPresent(String.self, forKey: .goal)
        self.height = try container.decode(Double.self, forKey: .height)
        self.username = try container.decodeIfPresent(String.self, forKey: .username)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.uid = try container.decodeIfPresent(String.self, forKey: .uid)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(bodyType, forKey: .bodyType)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
        try container.encodeIfPresent(gender, forKey: .gender)
        try container.encodeIfPresent(goal, forKey: .goal)
        try container.encode(height, forKey: .height)
        try container.encodeIfPresent(username, forKey: .username)
        try container.encode(weight, forKey: .weight)
        try container.encodeIfPresent(uid, forKey: .uid)
        try container.encodeIfPresent(email, forKey: .email)
    }
}
