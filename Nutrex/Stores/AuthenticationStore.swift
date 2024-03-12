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
            
    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(AuthError.unknown))
            }
        }
    }
}
