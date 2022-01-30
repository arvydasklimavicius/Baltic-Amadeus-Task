//
//  CoreDataManager.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    private init() {}
    
    private static let modelName = "Posts"
    
    static var managedContext: NSManagedObjectContext = {
        return storeContainer.viewContext
    }()
    
    static var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    static func saveContext() throws {
        guard managedContext.hasChanges else { return }
        
        try managedContext.save()
    }
    
    func applicationDocumentsDirectory() {
            if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                print(url.absoluteString)
            }
        }
}
