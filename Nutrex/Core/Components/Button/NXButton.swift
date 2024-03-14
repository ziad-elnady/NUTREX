//
//  NXButton.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

enum NXButtonVariant {
    case primary
    case secondary
    case outline
}

struct NXButton<Content: View>: View {
    @Environment(\.isEnabled) private var isEnabled
    
    var variant: NXButtonVariant
    var action: () -> Void
    var label: () -> Content
    
    init(variant: NXButtonVariant = .primary,
         action: @escaping () -> Void,
         @ViewBuilder label: @escaping () -> Content) {
        self.variant = variant
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action) {
            label()
                .font(.customFont(font: .orbitron, weight: .black, size: .body, relativeTo: .body))
                .foregroundColor(foregroundColorForVariant())
                .frame(height: 55.0)
                .padding(.horizontal)
                .background(backgroundForVariant())
                .opacity(isEnabled ? 1.0 : 0.25)
        }
    }
    
}

// MARK: - VIEWS -

extension NXButton {
    
    private func foregroundColorForVariant() -> Color {
        
        switch variant {
            
        case .primary:
                .black
        case .secondary:
                .black
        case .outline:
                .nxStroke
        }
        
    }
    
    @ViewBuilder
    private func backgroundForVariant() -> some View {
        if variant == .outline {
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(Color.nxStroke, lineWidth: 0.5)
        } else {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(variant == .primary ? .nxAccent : .primary)
        }
    }
    
}


#Preview {
    NXButton(variant: .secondary) {  } label: { Text("Button") }
}
