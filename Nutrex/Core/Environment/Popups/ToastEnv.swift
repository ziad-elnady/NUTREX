//
//  ToastEnv.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 20/03/2024.
//

import SwiftUI

struct ToastKey: EnvironmentKey {
    static let defaultValue: [ToastItem] = []
}

extension EnvironmentValues {
    var showToast: [ToastItem] {
        get { self[ToastKey.self] }
        set { self[ToastKey.self] = newValue }
    }
}
