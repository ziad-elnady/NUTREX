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
    
    enum UserError: Error {
        case errorFethchingUser
    }
    
    @Published var currentUser: User = User.empty
    
    @Published var hasError: Bool = false
    @Published var errorMessage: String? = nil
    
    private let db = Firestore.firestore()
    
    func saveUser(_ user: User) async throws {
        do {
            let userRef = db.collection("users").document(user.wrappedUid)
            try userRef.setData(from: user)
            
            currentUser = user
            
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
            let user = try snapshot.data(as: User.self, decoder: FirestoreStore.shared.decoder)
            self.currentUser = user
        } catch {
            print("Error fetching user data:", error)
            errorMessage = error.localizedDescription
            hasError = true
        }
    }
    
    func completeUserProfile(gender: Gender,
                             birthDay: Date,
                             weight: Double,
                             height: Double,
                             goal: Goal,
                             activity: ActivityLevel,
                             bodyType: BodyType) async throws {
        currentUser.gender          = gender.rawValue
        currentUser.dateOfBirth     = birthDay
        currentUser.weight          = weight
        currentUser.height          = height
        currentUser.goal            = goal.rawValue
        currentUser.bodyType        = bodyType.rawValue
        currentUser.activityLevel   = activity.rawValue
        currentUser.createdAt       = Date.now.onlyDate
        currentUser.updatedAt       = Date.now.onlyDate
        
        try await saveUser(currentUser)
    }
    
    private func getLocalUser(uid: String) throws -> User? {
        let managedObjectContext = CoreDataController.shared.viewContext
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uid == %@", uid)
        
            do {
                let users = try managedObjectContext.fetch(fetchRequest)
        
                if let localUser = users.first {
                    return localUser
                } else {
                    return nil
                }
            } catch {
                return nil
            }
    }
    
    func syncUser() async {
        do {
            if let localUser = try getLocalUser(uid: currentUser.wrappedUid) {
                if currentUser.wrappedUpdatedAt > localUser.wrappedUpdatedAt {
                    localUser.migrate(withUser: currentUser)
                    CoreDataController.shared.saveContext()
                } else {
                    currentUser.migrate(withUser: localUser)
                    currentUser = localUser
                    try await saveUser(currentUser)
                }
            }
        } catch {
            print("Cant migrate users: \(error)")
        }
    }
    
}
