//
//  ViewExt.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

extension View {
    func stroked() -> some View {
        self.modifier(StrokedModifier())
    }
}
