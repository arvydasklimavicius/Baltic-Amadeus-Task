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
    private var data = [Any]()
    


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
    
    func mergeArrays() {
        data = fetchedUsers + fetchedPosts
//        print(fetchedUsers[0].name)
//        print(fetchedPosts[0].title)
        
        for name in fetchedUsers {
            print(name)
        }
        
    }
    
    @IBAction func btnTapped(_ sender: Any) {
        
        mergeArrays()
//        print(data.enumerated())
        
        
    }
    

}

