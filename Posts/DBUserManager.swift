//
//  DBUserManager.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//

import Foundation
import CoreData

struct DBUserManager {
    
    static func getUsers() throws -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
        return try CoreDataManager.managedContext.fetch(fetchRequest)
    }
}
