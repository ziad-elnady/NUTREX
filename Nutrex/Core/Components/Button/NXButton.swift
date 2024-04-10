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
                .bodyFontStyle()
                .fontWeight(.semibold)
                .foregroundColor(foregroundColorForVariant())
                .frame(height: 55.0)
                .padding(.horizontal)
                .background {
                    if isEnabled {
                        backgroundForVariant()
                    }
                    else  {
                        disabledBackground()
                    }
                }
            
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
                .nxCard
        }
        
    }
    
    @ViewBuilder
    private func backgroundForVariant() -> some View {
        if variant == .outline {
            RoundedRectangle(cornerRadius: 16.0)
                .stroke(Color.nxCard, lineWidth: 0.5)
        } else {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(variant == .primary ? .nxAccent : .primary)
        }
    }
    
    @ViewBuilder
    private func disabledBackground() -> some View {
        RoundedRectangle(cornerRadius: 16.0)
            .fill(.nxLightGray)
    }
    
}


#Preview {
    NXButton(variant: .secondary) {  } label: { Text("Button") }
}
