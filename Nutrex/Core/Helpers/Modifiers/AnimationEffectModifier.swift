//
//  AnimationEffectModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

struct AnimationEffectModifier: ViewModifier {
    var isSelected = true
    var id: String
    var namespace: Namespace.ID

    func body(content: Content) -> some View {
        if isSelected {
            content.matchedGeometryEffect(id: id, in: namespace)
        } else {
            content
        }
    }
}
