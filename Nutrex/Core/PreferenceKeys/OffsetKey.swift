//
//  OffsetKey.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 25/03/2024.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
