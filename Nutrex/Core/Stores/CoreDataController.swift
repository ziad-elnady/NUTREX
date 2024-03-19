//
//  CoreDataController.swift
//  Nutrex
//
//  Created by Ziad Ahmed on 12/03/2024.
//

import CoreData

class CoreDataController: ObservableObject {
    
    static let shared = CoreDataController()
    let container = NSPersistentContainer(name: "NutrexDataModel")
        
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    static var previews: CoreDataController {
        let provider = CoreDataController(inMemory: true)
        let viewContext = provider.viewContext
        
        let nutritionalInfo = NutritionalInfo(context: viewContext)
        nutritionalInfo.caloriesPerGram = 1.4
        nutritionalInfo.proteinPerGram = 0.1
        nutritionalInfo.carbsPerGram = 0.001
        nutritionalInfo.fatPerGram = 0.009
        
        let food = Food(context: viewContext)
        food.name = "Egg"
        food.serving = 1.0
        food.unit = 1
        food.nutritionalInfo = nutritionalInfo
        
        let meal = Meal(context: viewContext)
        meal.name = "Oat Shake"
        meal.addToFoods(food)
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print(error.localizedDescription)
            }
        }
        
        return provider
    }
    
    init(inMemory: Bool = false) {
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
                return
            }
            
            self.container.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = self.viewContext
        }
        
    }

    func saveContext() {
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                viewContext.rollback()
                print(error.localizedDescription)
            }
        }
        
    }
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
    case missingManagedObjectContext
}
