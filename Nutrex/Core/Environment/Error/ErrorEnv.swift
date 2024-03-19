//
//  ErrorEnv.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

struct ShowErrorEnvironmentKey: EnvironmentKey {
    static var defaultValue: (Error, String) -> Void = { _, _ in }
}

extension EnvironmentValues {
    var showError: (Error, String) -> Void {
        get { self[ShowErrorEnvironmentKey.self] }
        set { self[ShowErrorEnvironmentKey.self] = newValue }
    }
}

