//
//  UserStore.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 14/03/2024.
//

import FirebaseFirestoreSwift
import FirebaseFirestore

import CoreData

@MainActor
class UserStore: ObservableObject {
    private let context = CoreDataController.shared.viewContext
    private let db = Firestore.firestore()
    
    @Published var currentUser: User = User.empty
    
    func saveUser(_ user: User) async throws {
        let userRef = db.collection("users").document(user.wrappedUid)
        try userRef.setData(from: user)
    }
    
    func fetchUser(forId uid: String) async throws {
        let snapshot = try await db.collection("users").document(uid).getDocument()
        let user = try snapshot.data(as: User.self, decoder: FirestoreStore.shared.decoder)
        
        currentUser.migrate(toUser: user)
        
        try await syncUser(withUser: user)
    }
    
    func completeUserProfile(config: ProfileSetupScreen.UserProfileSetupConfig) async throws {
        
        currentUser.completeProfile(withConfig: config)
        try await saveUser(currentUser)
        
        let localUser = User(context: context)
        localUser.migrate(toUser: currentUser)
        
        CoreDataController.shared.saveContext()
    }
    
    private func syncUser(withUser fbUser: User) async throws {
       
        let localUser = getLocalUser(forId: fbUser.wrappedUid) ?? User(context: context)
        guard !(localUser == fbUser) else { return }
                
        if localUser.isEmpty {
            localUser.migrate(toUser: fbUser)
            currentUser = localUser
            CoreDataController.shared.saveContext()
            
            return
        }
        
        if fbUser.wrappedUpdatedAt > localUser.wrappedUpdatedAt {
            localUser.migrate(toUser: fbUser)
            currentUser = localUser
            CoreDataController.shared.saveContext()
        } else if fbUser.wrappedUpdatedAt < localUser.wrappedUpdatedAt {
            fbUser.migrate(toUser: localUser)
            currentUser = fbUser
            try await saveUser(currentUser)
        }
    }
    
    private func getLocalUser(forId uid: String) -> User? {
        let fetchRequest = User.filteredUsersForID(uid)
        do {
            let user = try context.fetch(fetchRequest).first
            return user
        } catch {
            return nil
        }
    }
}
