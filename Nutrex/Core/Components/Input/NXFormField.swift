//
//  NXFormField.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

struct NXFormField: View {
    
    let label: String
    let isSecure: Bool
    @Binding var text: String
    
    var prefix: NXIcon? = nil
    var suffix: NXIcon? = nil
    
    init(_ label: String, text: Binding<String>, isSecure: Bool = false) {
        self.label = label
        self._text = text
        self.isSecure = isSecure
    }
    
    var body: some View {
        Group {
            HStack(spacing: 8.0) {
                prefix
                
                ProperTextField()
                
                suffix
            }
        }
        .font(.customFont(font: .ubuntu))
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled(true)
        .padding()
        .stroked()
    }
}

// MARK: - VIEWS -
extension NXFormField {
    
    @ViewBuilder
    private func ProperTextField() -> some View {
        if isSecure {
            SecureField(text: $text) {
                Text(label)
                    .foregroundStyle(.nxStroke)
            }
        } else {
            TextField(text: $text) {
                Text(label)
                    .foregroundStyle(.nxStroke)
            }
        }
    }
    
}

#Preview {
    NXFormField("placeholder", text: .constant(""))
}
