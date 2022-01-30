//
//  APIManager.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-22.
//

import Foundation

struct APIManager {
    
    private let decoder = JSONDecoder()
    private let usersEndpoint = "https://jsonplaceholder.typicode.com/users"
    private let postsEndpoint = "https://jsonplaceholder.typicode.com/posts"
    
    //MARK: - Fetch Users
    
    func getUsers(_ completion: @escaping (Result<[UserResponse], APIError>) -> ()) {
        performRequest(urlString: usersEndpoint) { result in
            switch result {
            case let .success(data):
                do {
                    let users = try decoder.decode([UserResponse].self, from: data)
                    completion(.success(users))
                }
                catch {
                    completion(.failure(.failedResponse))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Fetch Posts
    
    func getPosts(_ completion: @escaping(Result<[PostResponse], APIError>) -> ()) {
        performRequest(urlString: postsEndpoint ) { result in
            switch result {
            case let .success(data):
                do {
                    let posts = try decoder.decode([PostResponse].self, from: data)
                    completion(.success(posts))
                }
                catch {
                    completion(.failure(.failedResponse))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
    
    //MARK: - Create request
    
    private func performRequest(urlString: String, completion: @escaping (Result<Data, APIError>) -> ()) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(.success(data))
            } else {
                completion(.failure(.failedRequest))
            }
        }
        task.resume()
    }
}
