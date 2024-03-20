//
//  FireStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 11/03/2024.
//

import FirebaseFirestore
import Foundation

class FireStore {
    private let db = Firestore.firestore()
    
    func createUserDocument(uid: String, username: String, email: String, completion: @escaping (Error?) -> Void) async throws {
        let userData = [
            "username": username,
            "email": email
        ]
        
        try await db.collection("users").document(uid).setData(userData)
    }
}
