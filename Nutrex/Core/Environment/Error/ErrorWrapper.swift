//
//  ErrorWrapper.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import Foundation

struct ErrorWrapper: Identifiable {
    let id = UUID()
    
    let error: Error
    let message: String
}
