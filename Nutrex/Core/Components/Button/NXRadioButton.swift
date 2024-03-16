//
//  NXRadioButton.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 15/03/2024.
//

import SwiftUI

struct NXRadioButton: View {
    let text: String
    let selected: Bool
    let action: () -> Void
    
    init(_ text: String, selected: Bool = false, action: @escaping () -> Void) {
        self.text = text
        self.selected = selected
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8.0) {
                Text("⦿")
                    .font(.largeTitle)
                
                Text(text)
                    .font(.customFont(font: .audiowide))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 18.0)
            .padding(.vertical, 8.0)
            .overlay {
                Capsule(style: .circular)
                    .stroke(lineWidth: 2.0)
            }
        }
        .tint(selected ? .nxAccent : .secondary)
    }
}

#Preview {
    NXRadioButton("Radio", selected: true) {  }
}
