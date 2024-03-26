//
//  TransitionModifier.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 21/03/2024.
//

import SwiftUI

struct NXTransitionModifier: ViewModifier {
    var direction: HorizontalEdge
    
    func body(content: Content) -> some View {
        content
            .opacity(0)
            .offset(x: direction == .leading ? UIScreen.main.bounds.width : -UIScreen.main.bounds.width)
            .transition(.moveAndFade(direction: direction))
    }
}
