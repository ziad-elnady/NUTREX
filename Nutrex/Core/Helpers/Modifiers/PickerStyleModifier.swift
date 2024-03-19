//
//  PickerStyleModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

struct PickerStyleModifier: ViewModifier {
    var isSelected = true

    func body(content: Content) -> some View {
        content
            .foregroundStyle(isSelected ? .white : .black)
            .padding(.horizontal)
            .padding(.vertical, 8)
            .lineLimit(1)
            .clipShape(Capsule())
    }
}
