//
//  User+CoreDataProperties.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?

}

extension User : Identifiable {

}
