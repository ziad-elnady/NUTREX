//
//  LoadingScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 14/03/2024.
//

import SwiftUI

struct LoadingScreen: View {
    var title: String = "Loading..."
    
    var body: some View {
        ZStack(alignment: .center) {
            Color(.black.opacity(0.5))
                .blur(radius: 25.0)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            
            ProgressView {
                Text(title)
                    .font(.customFont(font: .orbitron, weight: .semiBold))
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 18.0).fill(.thinMaterial))
        }
    }
}

#Preview {
    AuthenticationScreen()
        .environmentObject(AuthenticationStore())
        .tint(.nxAccent)
}
