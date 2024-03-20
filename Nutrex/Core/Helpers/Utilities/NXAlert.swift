//
//  NXAlert.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

protocol NXAlert: Error, LocalizedError {
    var title: String { get }
    var description: String? { get }
    var actions: AnyView { get }
}

enum NXGenericAlert: NXAlert {
    case noInternetConnection(onOkPressed: () -> Void, onRetryPressed: () -> Void)
    case dataNotFound(onRetryPressed: () -> Void)
    
    var title: String {
        switch self {
        case .noInternetConnection:
            "No Internet Connection"
        case .dataNotFound:
            "Oops!"
        }
    }
    
    var description: String? {
        switch self {
        case .noInternetConnection:
           "Please check your internet connection and try again."
        case .dataNotFound:
            "Looks like we are running into a problem. Please try again later"
        }
    }
    
    var actions: AnyView {
        AnyView(buttons)
    }
    
    @ViewBuilder
    var buttons: some View {
        switch self {
        case .noInternetConnection(onOkPressed: let onOkPressed,
                                   onRetryPressed: let onRetryPressed):
            Button("Ok") {
                onOkPressed()
            }
            
            Button("Retry") {
                onRetryPressed()
            }
            
        case .dataNotFound(onRetryPressed: let onRetryPressed):
            Button("Retry") {
                onRetryPressed()
            }
        }
    }
}
