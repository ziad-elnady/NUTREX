//
//  AuthenticationScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

fileprivate struct AuthenticationScreenConfig {
    var isLoading = false
    
    var email: String = ""
    var username: String = ""
    var password: String = ""
    
    var isFormValid: Bool {
        if isRegistering {
            return !email.isEmpty && !username.isEmpty && !password.isEmpty
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
    
    var isRegistering = false
    
    mutating func resetFields() {
        email = ""
        username = ""
        password = ""
    }
}

fileprivate enum Field {
    case username, email, password
}

struct AuthenticationScreen: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var authStore: AuthenticationStore
    @EnvironmentObject private var userStore: UserStore
    
    @State private var config = AuthenticationScreenConfig()
    @FocusState private var focusedField: Field?
    
    let varticalTransition: AnyTransition = .asymmetric(
        insertion: .move(edge: .bottom),
        removal: .move(edge: .top))
    
    var body: some View {
        VStack {
            HeaderView()
            InputForm()
            ActionButton()
            AuthStateText()
            SeparatorView()
            AuthOptions()
            RightsReserved()
        }
        .padding()
        .alert(isPresented: $authStore.hasError) {
            Alert(
                title: Text("Error"),
                message: Text(authStore.errorMessage ?? "An error occurred"),
                dismissButton: .default(Text("OK")) {
                    config.resetFields()
                    authStore.errorMessage = nil
                }
            )
        }
        .overlay {
            if config.isLoading {
                LoadingScreen()
            }
        }
        
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
        .frame(maxHeight: .infinity)
    }
    
    @ViewBuilder
    private func InputForm() -> some View {
        VStack {
            if config.isRegistering {
                NXFormField("username", text: $config.username)
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .email
                    }
            }
            
            NXFormField("email@example.com", text: $config.email)
                .keyboardType(.emailAddress)
                .focused($focusedField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .password
                }
            
            NXFormField("•••••••", text: $config.password, isSecure: true)
                .focused($focusedField, equals: .password)
                .submitLabel(.done)
                .onSubmit {
                    focusedField = nil
                }
        }
        .transition(varticalTransition)
        .padding()
    }
    
    @ViewBuilder
    private func ActionButton() -> some View {
        NXButton(variant: .primary) {
            config.isRegistering ? signUp() : signIn()
        } label: {
            Text(config.isRegistering ? "sign up" : "login")
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .disabled(!config.isFormValid)
    }
    
    @ViewBuilder
    private func AuthStateText() -> some View {
        Group {
            Text((config.isRegistering ? "Already have and account?" : "Don't have an account?") + " ")
                .font(.customFont(font: .ubuntu, weight: .medium, size: .caption, relativeTo: .caption))
                .foregroundStyle(.nxSecondaryText)
            +
            Text(config.isRegistering ? "Login" : "Register")
                .font(.customFont(font: .ubuntu, weight: .bold, size: .caption, relativeTo: .caption))
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
        HStack(spacing: 12.0) {
            NXButton(variant: .outline) {
                print("sign in with google")
            } label: {
                HStack(spacing: 8.0) {
                    NXIcon(name: "google", iconSize: .large)
                    Text("Google")
                        .foregroundStyle(.white)
                }
                .font(.customFont(font: .ubuntu))
                .foregroundStyle(.primary)
                .frame(width: 100)
            }

            NXButton(variant: .outline) {
                print("sign in with apple")
            } label: {
                HStack(spacing: 12.0) {
                    NXIcon(name: "apple")
                    Text("Apple")
                        .foregroundStyle(.white)
                }
                .font(.customFont(font: .ubuntu))
                .foregroundStyle(.primary)
                .frame(width: 100)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder
    private func RightsReserved() -> some View {
        Text("All rights reserved ©")
            .font(.customFont(font: .ubuntu, size: .caption2, relativeTo: .caption2))
            .foregroundStyle(.nxSecondaryText)
            .padding()
    }
}

// MARK: - ACTIONS -
extension AuthenticationScreen {
    
    private func flipAuthState() {
        withAnimation {
            config.isRegistering.toggle()
        }
    }
    
    private func signIn() {
        focusedField = nil
        config.isLoading = true
        
        Task {
            await authStore.signIn(withEmail: config.email, password: config.password)
            config.isLoading = false
        }
    }
    
    private func signUp() {
        focusedField = nil
        config.isLoading = true
        
        Task {
            if let user = await authStore.signUp(withEmail: config.email,
                                                 password: config.password) {
                
                let newUser = User(context: context)
                newUser.uid = user.uid
                newUser.username = config.username
                newUser.email = config.email
                
                await userStore.saveUser(newUser)
                config.isLoading = false
            }
        }
    }
    
}

#Preview {
    AuthenticationScreen()
}
