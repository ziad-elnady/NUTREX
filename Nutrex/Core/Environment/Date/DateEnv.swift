//
//  DateEnv.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 17/03/2024.
//

import SwiftUI

struct SelectedDateKey: EnvironmentKey {
    static let defaultValue: Binding<Date> = .constant(Date())
}

extension EnvironmentValues {
    var selectedDate: Binding<Date> {
        get { self[SelectedDateKey.self] }
        set { self[SelectedDateKey.self] = newValue }
    }
}
