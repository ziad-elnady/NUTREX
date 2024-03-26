//
//  SplashLoadingScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 26/03/2024.
//

import SwiftUI

struct SplashLoadingScreen: View {
    var body: some View {
        ZStack {
            Color(.systemBackground)
            
            VStack(spacing: 8.0) {
                Spacer()
                ProgressView()
                Text("loading...")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 64.0)
            
            AppLogo()
                .frame(width: 220.0, height: 35.0)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashLoadingScreen()
}
