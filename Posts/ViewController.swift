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
//                    print(self?.fetchedUsers)
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
    

    
    func createPost() {
        for i in fetchedUsers {
            for x in fetchedPosts {
                if i.id == x.userId {
                    userPost.append(UserPost(userId: i.id, userName: i.name, postTitle: x.title))
                }
            }
        }
    }
    
    @IBAction func btnTapped(_ sender: Any) {

        createPost()
        print("name: \(userPost[0].userName),\npost: \(userPost[0].postTitle)")
        
    }
    

}

