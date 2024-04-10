//
//  AuthenticationScreen.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import SwiftUI

fileprivate struct AuthenticationScreenConfig {
    var isLoading = false
    
    var email: String = "ziad@gmail.com"
    var username: String = "ziad"
    var password: String = "111111"
    
    var isFormValid: Bool {
        if isRegistering {
            return !email.isEmpty && !username.isEmpty && !password.isEmpty
        } else {
            return !email.isEmpty && !password.isEmpty
        }
    }
    
    var isRegistering = false
}



struct AuthenticationScreen: View {
    enum Field {
        case username, email, password
    }
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject private var authStore: AuthenticationStore
    @EnvironmentObject private var userStore: UserStore
    
    @State private var config = AuthenticationScreenConfig()
    @State private var alert: NXAuthAlert? = nil
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
        .overlay {
            if config.isLoading {
                LoadingScreen()
            }
        }
        .showAlert(alert: $alert)
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
                .foregroundStyle(.nxLightGray)
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
        HStack(spacing: 4.0) {
            Text((config.isRegistering ? "Already have and account?" : "Don't have an account?") + " ")
                .captionFontStyle()
                .foregroundStyle(.nxLightGray)
            
            Text(config.isRegistering ? "Login" : "Register")
                .captionFontStyle()
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
                .captionFontStyle()
                .foregroundStyle(.nxLightGray)
            
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
                .bodyFontStyle()
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
                .bodyFontStyle()
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
            .caption2FontStyle()
            .foregroundStyle(.nxLightGray)
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
           do {
               try  await authStore.signIn(withEmail: config.email,
                                       password: config.password)
                
           } catch {
               alert = .error(error)
           }
            
            config.isLoading = false
        }
    }
    
    private func signUp() {
        focusedField = nil
        config.isLoading = true
        
        Task {
            do {
                let user = try await authStore.signUp(withEmail: config.email,
                                           password: config.password)
                
                let newUser = User(context: context)
                newUser.uid = user?.uid
                newUser.username = config.username
                newUser.email = config.email
                
                CoreDataController.shared.saveContext()
                
                try await userStore.saveUser(newUser)
                
            } catch {
                alert = .error(error)
            }
            
            config.isLoading = false
        }
    }
    
}

#Preview {
    AuthenticationScreen()
        .environmentObject(AuthenticationStore())
        .environmentObject(UserStore())
}
