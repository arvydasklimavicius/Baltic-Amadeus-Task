//
//  ViewController.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-20.
//

import UIKit

class ViewController: UIViewController {
    
    private let apiManager = APIManager()
    private let dispatchGroup = DispatchGroup()
    
    private var fetchedUsers = [User]()
    private var fetchedPosts = [Post]()
    private var userPost = [UserPost]()
    
    @IBOutlet weak var postsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsTableView.dataSource = self
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
            self.postsTableView.reloadData()
        }
    }
    
    func printPost() {
        for i in userPost {
            print("\(i.userName) - \(i.postTitle)")
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userPost.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPostCell", for: indexPath)
        
        guard
            indexPath.row < userPost.count,
            let userPostCell = cell as? UserPostTableViewCell
        else {
            return cell
        }
        userPostCell.configureCell(name: userPost[indexPath.row].userName, post: userPost[indexPath.row].postTitle)
        return userPostCell
    }
    
    
}

