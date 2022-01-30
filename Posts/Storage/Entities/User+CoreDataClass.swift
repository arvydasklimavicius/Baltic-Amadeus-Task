//
//  User+CoreDataClass.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    required convenience public init(from decoder: Decoder) throws {
        
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("NSManagedObjectContext is missing") }
        
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)!
        self.init(entity: entity, insertInto: context)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int16.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
   
    }
 

}

extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

extension JSONDecoder {
    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
}

