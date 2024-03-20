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
    
    init() {
        Auth.auth().addStateDidChangeListener { auth, user in
            self.userSession = user
            self.isAuthenticated = user != nil
        }
    }
    
    func signUp(withEmail email: String, password: String) async throws -> FirebaseAuth.User? {
            let authResult = try await auth.createUser(withEmail: email, password: password)
            self.userSession = authResult.user
            
            return authResult.user
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        let authResult = try await auth.signIn(withEmail: email, password: password)
        self.userSession = authResult.user
    }
    
}
