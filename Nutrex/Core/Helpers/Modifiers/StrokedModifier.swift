//
//  StrokedModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

struct StrokedModifier: ViewModifier {
    var strokeColor: Color = .nxStroke
    var borderWidth: CGFloat = 0.5
    var backgroundColor: Color = .nxMaterial

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: 16.0)
                    .strokeBorder(strokeColor, lineWidth: borderWidth)
                    .background(RoundedRectangle(cornerRadius: 16.0).fill(backgroundColor))
            )
    }
}




