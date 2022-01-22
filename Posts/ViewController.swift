//
//  ViewController.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-20.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiManager = APIManager()
    private var fetchedUsers = [User]()
    private var fetchedPosts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        // Do any additional setup after loading the view.
        loadUsers()
        loadPosts()
        
       
    }
    
    private func loadUsers() {
        apiManager.getUsers { [ weak self ] result in
            DispatchQueue.main.async { [ self ] in
                switch result {
                case .success(let users):
                    self?.fetchedUsers.append(contentsOf: users)
                    print(self?.fetchedUsers)
                default:
                    break
                }
            }
        }
    }
    
    private func loadPosts() {
        apiManager.getPosts { [weak self] result in
            DispatchQueue.main.async {
                [ self ] in
                switch result {
                case .success(let posts):
                    self?.fetchedPosts.append(contentsOf: posts)
                default:
                    break
                }
            }
        }
    }
    
    func createPost(userId: User, post: Post) -> String {
        let postUser = post.userId
        let postTitle = userId.name
        return "\(postUser) \(postTitle)"
    }


}

