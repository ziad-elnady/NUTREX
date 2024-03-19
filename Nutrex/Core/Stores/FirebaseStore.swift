//
//  FirebaseStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 18/03/2024.
//

import FirebaseFirestore

class FirestoreStore {
    
    static let shared = FirestoreStore()

    var db: Firestore {
        Firestore.firestore()
    }

    var decoder: Firestore.Decoder {
        let decoder = Firestore.Decoder()
        decoder.userInfo[.managedObjectContext] = CoreDataController.shared.viewContext
        return decoder
    }
    
}
