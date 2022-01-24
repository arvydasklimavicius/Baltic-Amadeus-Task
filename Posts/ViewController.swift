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
    private var userPost = [UserPost]()
    private let dispatchGroup = DispatchGroup()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        start()

        
        
    }
    
    private func loadUsers() {
        dispatchGroup.enter()
        apiManager.getUsers { [ weak self ] result in
            DispatchQueue.main.async { [ self ] in
                switch result {
                case .success(let users):
                    self?.fetchedUsers.append(contentsOf: users)
                    self?.dispatchGroup.leave()
                default:
                    break
                }
            }
        }
    }
    
    private func loadPosts() {
        dispatchGroup.enter()
        apiManager.getPosts { [weak self] result in
            DispatchQueue.main.async {
                [ self ] in
                switch result {
                case .success(let posts):
                    self?.fetchedPosts.append(contentsOf: posts)
                    self?.dispatchGroup.leave()
                default:
                    break
                }
            }
        }
    }
    

    
    func createPost() {
        for i in fetchedUsers {
            for x in fetchedPosts {
                if i.id == x.userId {
                    userPost.append(UserPost(userId: i.id, userName: i.name, postTitle: x.title))
                }
            }
        }
        printPost()
    }
    
    func start() {
        loadUsers()
        loadPosts()
        dispatchGroup.notify(queue: .main) {
            self.createPost()
        }
    }
    
    func printPost() {
        for i in userPost {
            print("\(i.userName) - \(i.postTitle)")
        }
    }
    
    @IBAction func btnTapped(_ sender: Any) {

        
    }
    

}

