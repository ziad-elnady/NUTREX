//
//  AuthenticationScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

fileprivate struct AuthenticationScreenConfig {
    var email: String = ""
    var username: String = ""
    var password: String = ""
    
    var isLoggingIn = false
}

struct AuthenticationScreen: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var config = AuthenticationScreenConfig()
    
    let varticalTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .bottom),
        removal: .move(edge: .top))
    
    var body: some View {
        VStack {
            Spacer()
            
            HeaderView()
                        
            Spacer()
            
            InputForm()
            
            ActionButton()
            
            AuthStateText()
            
            SeparatorView()
            
            AuthOptions()
            
            RightsReserved()
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.never)
    }
}

// MARK: - VIEWS -
extension AuthenticationScreen {
    
    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            Text("WELCOME TO")
                .font(.customFont(font: .audiowide, size: .title, relativeTo: .title))
            
            AppLogo()
                .frame(width: 230, height: 41)
            
            Text("where your journy\n begins")
                .font(.customFont(font: .audiowide, size: .body, relativeTo: .body))
                .fixedSize()
                .foregroundStyle(.nxSecondaryText)
                .multilineTextAlignment(.center)
                .padding(.top)
        }
        .transition(varticalTransition)
    }
    
    @ViewBuilder
    private func InputForm() -> some View {
        VStack {
            if config.isLoggingIn {
                NXFormField("username", text: $config.username)
            }
            
            NXFormField("email@example.com", text: $config.email)
            
            NXFormField("•••••••", text: $config.password, secured: true)
        }
        .transition(varticalTransition)
        .padding()
    }
    
    @ViewBuilder
    private func ActionButton() -> some View {
        NXButton(variant: .primary) {
            print("sign in | sign up")
        } label: {
            Text(config.isLoggingIn ? "Login" : "Sign up")
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func AuthStateText() -> some View {
        Group {
            Text(config.isLoggingIn ? "Don't have an account?  ": "Already have and account?  ")
                .font(.customFont(font: .orbitron, size: .caption, relativeTo: .caption))
                .foregroundStyle(.nxSecondaryText)
            +
            Text(config.isLoggingIn ? "Login": "Register")
                .font(.customFont(font: .orbitron, weight: .bold, size: .caption, relativeTo: .caption))
        }
        .onTapGesture {
            flipAuthState()
        }
        .padding(.vertical)
    }
    
    @ViewBuilder
    private func SeparatorView() -> some View {
        HStack(spacing: 24.0) {
            Separator()
            
            Text("or")
                .font(.customFont(font: .orbitron, size: .caption, relativeTo: .caption))
                .foregroundStyle(.nxStroke)
            
            Separator()
        }
        .padding(.horizontal, 32.0)
    }
    
    @ViewBuilder
    private func AuthOptions() -> some View {
        HStack {
            NXButton(variant: .outline) {
                print("sign in with google")
            } label: {
                HStack(spacing: 12.0) {
                    NXIcon(name: "google", iconSize: .large)
                    Text("Google")
                }
                .font(.customFont(font: .ubuntu))
                .foregroundStyle(.primary)
            }

            NXButton(variant: .outline) {
                print("sign in with apple")
            } label: {
                HStack(spacing: 12.0) {
                    NXIcon(name: "apple", iconSize: .large)
                    Text("Apple")
                }
                .font(.customFont(font: .ubuntu))
                .foregroundStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder
    private func RightsReserved() -> some View {
        Text("All rights reserved ©")
            .font(.customFont(font: .orbitron, size: .caption2, relativeTo: .caption2))
            .foregroundStyle(.nxStroke)
            .padding()
    }
}

// MARK: - ACTIONS -
extension AuthenticationScreen {
    
    private func flipAuthState() {
        withAnimation {
            config.isLoggingIn.toggle()
        }
    }
    
}

#Preview {
    AuthenticationScreen()
}
