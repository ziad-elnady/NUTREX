//
//  NXFormField.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 13/03/2024.
//

import SwiftUI

struct NXFormField<Prefix: View, Suffix: View>: View {
    
    let label: String
    var secured: Bool = false
    @Binding var text: String
    
    var prefix: (() -> Prefix)?
    var suffix: (() -> Suffix)?
    
    init(_ label: String,
         text: Binding<String>,
         @ViewBuilder prefix: @escaping () -> Prefix,
         @ViewBuilder suffix: @escaping () -> Suffix) {
        self._text = text
        self.label = label
        
        self.prefix = prefix
        self.suffix = suffix
    }
    
    init(_ label: String,
         text: Binding<String>,
         @ViewBuilder prefix: @escaping () -> Prefix) where Prefix == EmptyView {
        self._text = text
        self.label = label
        
        self.prefix = prefix
    }
    
    init(_ label: String,
         text: Binding<String>,
         @ViewBuilder suffix: @escaping () -> Suffix) where Suffix == EmptyView {
        self._text = text
        self.label = label
        
        self.suffix = suffix
    }
    
    init(_ label: String, text: Binding<String>, secured: Bool = false) where Prefix == EmptyView, Suffix == EmptyView {
        self._text = text
        self.label = label
        
        self.prefix = { EmptyView() }
        self.suffix = { EmptyView() }
    }
    
    var body: some View {
        Group {
            HStack(spacing: 8.0) {
                prefix?()
                
                ProperTextField()
                
                suffix?()
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
        if secured {
            TextField(text: $text) {
                Text(label)
                    .foregroundStyle(.nxStroke)
            }
        } else {
            SecureField(text: $text) {
                Text(label)
                    .foregroundStyle(.nxStroke)
            }
        }
    }
    
}

#Preview {
    NXFormField("placeholder", text: .constant(""))
}
