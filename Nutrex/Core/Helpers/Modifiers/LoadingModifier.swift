//
//  LoadingModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

struct LoadingViewModifier: ViewModifier {
    let title: String
    let isLoading: Bool
    
    init(_ title: String, isLoading: Bool) {
        self.title = title
        self.isLoading = isLoading
    }
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if isLoading {
                    LoadingScreen(title: title)
                }
            }
    }
}
