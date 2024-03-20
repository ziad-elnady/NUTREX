//
//  NXAuthAlert.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

enum AuthError: NXAlert {
    case invalidPassword(onOkPressed: () -> Void)
    case emailAlreadyExists(onOkPressed: () -> Void)
    case unknown(onRetryPressed: () -> Void)
    
    var title: String {
        switch self {
        case .invalidPassword:
            return "The provided value for the password user property is invalid. It must be a string with at least six characters."
        case .emailAlreadyExists:
            return "The provided email is already in use by an existing user. Each user must have a unique email."
        case .unknown:
            return "Unkown Error"
        }
    }
    
    var description: String? {
        switch self {
        case .invalidPassword:
            return "The provided value for the password user property is invalid. It must be a string with at least six characters."
        case .emailAlreadyExists:
            return "The provided email is already in use by an existing user. Each user must have a unique email."
        case .unknown:
            return "Unkown Error"
        }
    }
    
    var actions: AnyView {
        AnyView(buttons)
    }
    
    @ViewBuilder
    var buttons: some View {
        switch self {
        case .invalidPassword(let onOkPressed):
            Button("Ok") {
                onOkPressed()
            }
        case .emailAlreadyExists(let onOkPressed):
            Button("Ok") {
                onOkPressed()
            }
        case .unknown(let onRetryPressed):
            Button("Retry") {
                onRetryPressed()
            }
        }
    }
}
