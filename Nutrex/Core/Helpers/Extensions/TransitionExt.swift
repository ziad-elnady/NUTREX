//
//  TransitionExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 21/03/2024.
//

import SwiftUI

extension AnyTransition {
    static func moveAndFade(direction: HorizontalEdge) -> AnyTransition {
        return .asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))
    }
}
