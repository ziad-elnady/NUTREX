//
//  UserStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 14/03/2024.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

import Foundation

@MainActor
class UserStore: ObservableObject {
    @Published var currentUser: User = User.empty
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    
    func saveUser(_ user: User) async {
        do {
            print(user.wrappedUid)
            let userRef = db.collection("users").document(user.wrappedUid)
            try userRef.setData(from: user)
            
            currentUser = user
            errorMessage = nil
            hasError = false
            
            await fetchUser(forId: user.wrappedUid)
        } catch {
            print("Error uploading user data:", error)
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    func fetchUser(forId uid: String) async {
        do {
            let snapshot = try await db.collection("users").document(uid).getDocument()
            if let user = try? snapshot.data(as: User.self) {
                currentUser = user
            }
        } catch {
            print("Error fetching user data:", error)
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
}
