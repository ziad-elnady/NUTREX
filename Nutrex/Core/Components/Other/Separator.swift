//
//  Separator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Rectangle()
            .frame(height: 0.5)
            .overlay(.nxCard)
    }
}

#Preview {
    Separator()
}
