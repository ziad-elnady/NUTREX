//
//  AuthErrors.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import Foundation

enum AuthError: Error {
    case invalidPassword
    case emailAlreadyExists
    case unknown
    
    var description: String {
        switch self {
        case .invalidPassword:
            return "The provided value for the password user property is invalid. It must be a string with at least six characters."
        case .emailAlreadyExists:
            return "The provided email is already in use by an existing user. Each user must have a unique email."
        case .unknown:
            return "Unkown Error"
        }
    }
}
