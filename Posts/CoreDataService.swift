//
//  CoreDataService.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-29.
//

import Foundation
import UIKit
import CoreData

class CoreDataService {
    
    private init() {}
    static let shared = CoreDataService()
    
//    enum Result<T> {
//        case Success(T)
//        case Error(String)
//    }
//
    private let usersEndpoint = "https://jsonplaceholder.typicode.com/users"
    
    
//    func getDataWith(completion: @escaping (Result<[String: AnyObject]>) -> Void) {
//
//        let urlString = usersEndpoint
//
//        guard let url = URL(string: urlString) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//
//            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
//            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
//            }
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
//                    guard let itemsJsonArray = json["items"] as? [[String: AnyObject]] else {
//                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
//                    }
//                    DispatchQueue.main.async {
//                        completion(.Success(itemsJsonArray))
//                    }
//                }
//            } catch let error {
//                return completion(.Error(error.localizedDescription))
//            }
//        }.resume()
        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//           guard error == nil else { return }
//           guard let data = data else { return }
//               do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
//                    DispatchQueue.main.async {
//                  completion(.Success(json))
//                        print(json)
//                }
//               }
//              } catch let error {
//               print(error)
//            }
//        }.resume()
//    }
    
//    func parseApiCall() {
//
//
//        let urlString = usersEndpoint
//
//        guard let url = URL(string: urlString) else { return  }
//        do {
//            let data = try Data(contentsOf: url)
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
//
//            guard let array = json as? [Any] else { return }
//            for user in array {
//                guard let userDict = user as? [String: Any] else { return }
//                guard let userId = userDict["id"] as? Int else {print("not an Int"); return }
//                guard let userName = userDict["name"] as? String else { return }
//                guard let userCompany = userDict["company"] as? [String: String] else { return }
//                guard let companyName = userCompany["name"] else { return }
//
//                print(userId)
//                print(userName)
//                print(companyName)
//                print("  ")
//            }
//        } catch {
//            print(error)
//        }
//    }
//
//    func createUserEntity(dictionary: [String: AnyObject]) -> NSManagedObject? {
//        let context = CoreDataManager.storeContainer.viewContext
//        if let userEntity = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as? User {
//            userEntity.id = dictionary["id"] as! Int16
//            userEntity.name = dictionary["name"] as? String
//            return userEntity
//        }
//        return nil
//    }
//
//
//    func saveInCoreDataWith(array: [[String: AnyObject]]) {
//        _ = array.map { self.createUserEntity(dictionary: $0)}
//        do {
//            try
//            CoreDataManager.storeContainer.viewContext.save()
//
//        } catch let error {
//            print(error)
//        }
//    }
    
    func fetchJSON(url: URL, completion: @escaping (Result<[User], APIError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let jsonData = data, let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 || httpResponse.statusCode == 200, error == nil else {
                
                if let error = error as NSError?, error.domain == NSURLErrorDomain {
                    
                    completion(.failure(.failedResponse))
                }
                return
            }
            
            //MARK: Get Data Back
            do {
                
                let decoder = JSONDecoder.init(context: PersistenceService.shared.persistentContainer.viewContext)
                let data = try decoder.decode([User].self, from: jsonData)
                ViewController.shared.coreDataUsers = data
                
                let users = User(context: PersistenceService.shared.persistentContainer.viewContext)
                
                data.forEach { (user) in
                    users.id = user.id
                    users.name = user.name
                
                completion(.success(data))
                    ViewController.shared.coreDataUsers = data
                }
                
                DispatchQueue.main.async {
//                    HomeController.shared.tableView.reloadData()
                    PersistenceService.shared.save()
                }
                
            } catch {
                completion(.failure(.unexpectedDataFormat))
            }
        } .resume()
    }
    
    func applicationDocumentsDirectory() {
            if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
                print(url.absoluteString)
            }
        }
}
    
    

