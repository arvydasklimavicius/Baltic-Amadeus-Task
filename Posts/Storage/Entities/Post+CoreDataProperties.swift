//
//  Post+CoreDataProperties.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//
//

import Foundation
import CoreData


extension Post {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Post> {
        return NSFetchRequest<Post>(entityName: "Post")
    }

    @NSManaged public var userId: Int16
    @NSManaged public var title: String?

}

extension Post : Identifiable {

}
