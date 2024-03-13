//
//  Separator.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

struct Separator: View {
    var body: some View {
        Divider()
            .frame(maxWidth: .infinity, maxHeight: 0.5)
            .background(.nxStroke)
    }
}

#Preview {
    Separator()
}
