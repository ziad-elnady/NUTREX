//
//  GlassEffectModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 06/04/2024.
//

import SwiftUI

struct GlassEffectModifier: ViewModifier {
    private var cornerRadius: CGFloat
    
    private let gradientColors: [Color] = [
        Color.white.opacity(0.65),
        Color.white.opacity(0.1),
        Color.white.opacity(0.1),
        Color.white.opacity(0.4),
        Color.white.opacity(0.5)
    ]
    
    init(_ cornerRadius: CGFloat = 25.0) {
        self.cornerRadius = cornerRadius
    }
    
    func body(content: Content) -> some View {
        content
            .background {
                RoundedRectangle(cornerRadius: 25.0)
                    .fill(Material.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 5 , y: 5)
            }
            .overlay {
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(LinearGradient(colors: gradientColors, startPoint: .topLeading, endPoint: .bottomTrailing))
            }
    }
}
