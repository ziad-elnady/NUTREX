//
//  NXAuthAlert.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

enum NXAuthAlert: NXAlert {
    case noUserSession(onOkPressed: () -> Void)
    case invalidPassword(onOkPressed: () -> Void)
    case emailAlreadyExists(onOkPressed: () -> Void)
    case error(_ error: Error)
    case unknown(onOkPressed: () -> Void, onRetryPressed: () -> Void)
    
    var title: String {
        switch self {
        case .noUserSession:
            return "No User"
        case .invalidPassword:
            return "Invalid Password"
        case .emailAlreadyExists:
            return "Email Already Exists"
        case .error:
            return "Oops!"
        case .unknown:
            return "Unkown Error"
        }
    }
    
    var description: String? {
        switch self {
        case .noUserSession:
            return "There is no user logged it at the moment."
        case .invalidPassword:
            return "The provided value for the password user property is invalid. It must be a string with at least six characters."
        case .emailAlreadyExists:
            return "The provided email is already in use by an existing user. Each user must have a unique email."
        case .error(let error):
            return error.localizedDescription
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
        case .noUserSession(let onOkPressed):
            Button("Ok") {
                onOkPressed()
            }
        case .invalidPassword(let onOkPressed):
            Button("Ok") {
                onOkPressed()
            }
        case .emailAlreadyExists(let onOkPressed):
            Button("Ok") {
                onOkPressed()
            }
        case .error(_):
            Button("Ok") { }
        case .unknown(let onOkPressed, let onRetryPressed):
            Button("Ok") {
                onOkPressed()
            }
            Button("Retry") {
                onRetryPressed()
            }
            
        }
    }
}
