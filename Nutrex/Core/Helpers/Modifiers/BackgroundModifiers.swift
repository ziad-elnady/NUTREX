//
//  BackgroundModifiers.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 26/04/2024.
//

import SwiftUI

struct CardedModifier: ViewModifier {
    private var cornerRadius: CGFloat

    init(_ cornerRadius: CGFloat = 25.0) {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(Color.nxCard)
            }
    }
}
