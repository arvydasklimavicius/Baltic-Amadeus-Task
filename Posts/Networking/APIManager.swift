//
//  APIManager.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-22.
//

import Foundation

struct APIManager {
    
    private let decoder = JSONDecoder()
    
//MARK: - Fetch Users
    
    func getUsers(_ completion: @escaping (Result<[User], Error>) -> ()) {
        performRequest(urlString: "https://jsonplaceholder.typicode.com/users") { result in
            switch result {
            case let .success(data):
                do {
                    let users = try decoder.decode([User].self, from: data)
                    completion(.success(users))
//                    print("🟣\(users)")
                }
                catch {
                    completion(.failure(error.localizedDescription as! Error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    func getPosts(_ completion: @escaping(Result<[Post], Error>) -> ()) {
        performRequest(urlString: "https://jsonplaceholder.typicode.com/posts") { result in
            switch result {
            case let .success(data):
                do {
                    let posts = try decoder.decode([Post].self, from: data)
                    completion(.success(posts))
//                    print("🟢🟢🟢\(posts)")
                }
                catch {
                    completion(.failure(error.localizedDescription as! Error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(error?.localizedDescription as! Error))
            }
        }
        task.resume()
    }
    
    
}
