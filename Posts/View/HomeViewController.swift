//
//  ViewController.swift
//  Posts
//
//  Created by Arvydas Klimavicius on 2022-01-20.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    private let apiManager = APIManager()
    private let dispatchGroup = DispatchGroup()
    
    private var fetchedUsers = [UserResponse]()
    private var fetchedPosts = [PostResponse]()
    private var userPost = [UserPost]()
    
    @IBOutlet weak var postsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        postsTableView.dataSource = self
        start()
    }
    
    //MARK: - Network call
    
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

    func createPostToShow() {
        for user in fetchedUsers {
            for post in fetchedPosts {
                if user.id == post.userId {
                    userPost.append(UserPost(userId: user.id, userName: user.name, postTitle: post.title))
                }
            }
        }
    }

    //MARK: - Load data to TableView

    func start() {
        loadUsers()
        loadPosts()
        dispatchGroup.notify(queue: .main) {
            self.createPostToShow()
            self.postsTableView.reloadData()
            self.clearData()
            self.savePostToCoreData(self.userPost)
        }
    }
    
    //MARK: - Save posts to CoreData
    
    func savePostToCoreData(_ posts: [UserPost]) {
        let context = CoreDataManager.storeContainer.viewContext
        for post in posts {
            let newPost = NSEntityDescription.insertNewObject(forEntityName: "DBUserPost", into: context)
            newPost.setValue(post.userId, forKey: "userId")
            newPost.setValue(post.userName, forKey: "userName")
            newPost.setValue(post.postTitle, forKey: "postTitle")
        }
        do {
            try context.save()
            print("🟠 Success")
        } catch {
            print("Error saving \(error)")
        }
    }
    
    //MARK: - Clear CoreData
    
    private func clearData() {
            do {
                let context = CoreDataManager.storeContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DBUserPost")
                do {
                    let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                    _ = objects.map{$0.map{context.delete($0)}}
                    try CoreDataManager.saveContext()
                } catch let error {
                    print("ERROR DELETING : \(error)")
                }
            }
        }
}

//MARK: - TableView data source

extension HomeViewController: UITableViewDataSource {
    
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

