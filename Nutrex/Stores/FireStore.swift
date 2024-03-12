//
//  FireStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 11/03/2024.
//

import FirebaseFirestore
import Foundation

@MainActor
class FireStore: ObservableObject {
    private let db = Firestore.firestore()
    
    func createUserDocument(uid: String, username: String, email: String, completion: @escaping (Error?) -> Void) {
        let userData = [
            "username": username,
            "email": email
            // Add other user data fields as needed
        ]
        
        db.collection("users").document(uid).setData(userData) { error in
            completion(error)
        }
    }
    
    // Implement other Firestore-related operations and error handling here
}
