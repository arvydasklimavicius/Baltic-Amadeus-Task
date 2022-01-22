//
//  APIManager.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-22.
//

import Foundation

struct APIManager {
    
    private let decoder = JSONDecoder()
    
    func getUsers(_ completion: @escaping (Result<[User], Error>) -> ()) {
        performUserRequest(urlString: "https://jsonplaceholder.typicode.com/users") { result in
            switch result {
            case let .success(data):
                do {
                    let users = try decoder.decode([User].self, from: data)
                    completion(.success(users))
                    print(users)
                }
                catch {
                    completion(.failure(error.localizedDescription as! Error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    private func performUserRequest(urlString: String, completion: @escaping (Result<Data, Error>) -> ()) {
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
