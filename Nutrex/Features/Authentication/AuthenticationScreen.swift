//
//  AuthenticationScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

struct AuthenticationScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Text("Authentication Screen")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
    }
}

#Preview {
    AuthenticationScreen()
}
