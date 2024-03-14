//
//  AuthenticationStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 11/03/2024.
//

import Foundation

import Firebase
import FirebaseAuth

@MainActor
class AuthenticationStore: ObservableObject {
    let auth = Auth.auth()
    
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticated = false
    
    @Published var errorMessage: String? = nil
    @Published var hasError = false
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.userSession = user
            self.isAuthenticated = user != nil
        }
    }
    
    func signUp(withEmail email: String, password: String) async -> FirebaseAuth.User? {
        do {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            self.userSession = authResult.user
            self.isAuthenticated = true
            self.errorMessage = nil
            
            return authResult.user
        } catch {
            self.hasError = true
            self.errorMessage = error.localizedDescription
            
            return nil
        }
    }
    
    func signIn(withEmail email: String, password: String) async {
        do {
            let authResult = try await auth.signIn(withEmail: email, password: password)
            self.userSession = authResult.user
            self.isAuthenticated = true
            self.errorMessage = nil
        } catch {
            self.hasError = true
            self.errorMessage = error.localizedDescription
        }
    }
    
}
