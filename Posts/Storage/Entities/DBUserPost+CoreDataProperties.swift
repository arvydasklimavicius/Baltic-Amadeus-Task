//
//  DBUserPost+CoreDataProperties.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//
//

import Foundation
import CoreData


extension DBUserPost {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DBUserPost> {
        return NSFetchRequest<DBUserPost>(entityName: "DBUserPost")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var userName: String?
    @NSManaged public var postTitle: String?

}

extension DBUserPost : Identifiable {

}
