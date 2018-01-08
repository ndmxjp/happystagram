//
//  ViewController.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/02.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Floaty
import Parse
import ParseUI

class ViewController: UIViewController {
    
//    var post = Post.allPosts
    var posts = [Post]() {
        didSet {
            tableView.reloadData()
        }
    }

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor as NSAttributedStringKey: UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1019607843, green: 0.137254902, blue: 0.4941176471, alpha: 1)
        title = "Happystagram"
        
        tableView.dataSource = self
        
        let floaty = Floaty()
        floaty.fabDelegate = self
        self.view.addSubview(floaty)
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "postCell")
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(ViewController.refreshControlValueChanged(sender:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let user = PFUser.current()
        
        if user == nil {
            presentLoginViewController();
        } else {
            fetchPosts(callback: nil)
            
            //local notification
            let center = NotificationCenter.default
            center.addObserver(forName: Notification.Name.newPostCreated, object: nil, queue: OperationQueue.main, using: { (notification) in
                if let newPost = notification.userInfo?["newPostObject"] as? Post {
                    if !self.postWasDisplayed(newPost: newPost) {
                        self.posts.insert(newPost, at: 0)
                    }
                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCommentView" {
            let commentViewController = segue.destination as! CommentViewController
            commentViewController.post = sender as! Post
        }
    }
    
    @objc func refreshControlValueChanged(sender: UIRefreshControl) {
        fetchPosts {
            sender.endRefreshing()
        }
    }
    
    // fetch the posts with query
    func fetchPosts(callback: (()->Void)?) {
        let postQuery = PFQuery(className: Post.parseClassName())
        postQuery.order(byDescending: "updatedAt")
        postQuery.cachePolicy = .cacheThenNetwork
        postQuery.includeKey("user")
        postQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
//                エラーなし
                if let postObjects = objects {
                    self.posts = postObjects.map({ (pfObject) -> Post in
                        return pfObject as! Post
                    })
                    print(self.posts)
                    callback?()
                }
            } else {
//                エラーあり
                print(error)
            }
        }
    }
    
    func postWasDisplayed(newPost: Post) -> Bool {
        return posts.contains(newPost)
    }

    @IBAction func tapSettingButtonAction(_ sender: Any) {
        performSegue(withIdentifier: "toSettingView", sender: nil)
    }
    
}

// MARK: TableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        cell.post = posts[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: FloatyDelegate
extension ViewController: FloatyDelegate {

    func emptyFloatySelected(_ floaty: Floaty){
        print("tapped")
        self.performSegue(withIdentifier: "new post composer", sender: self)
    }
}

// MARK: PostTableViewCellDelegate
extension ViewController: PostTableViewCellDelegate {
    func commentButtonClicked(post: Post) {
        self.performSegue(withIdentifier: "toCommentView", sender: post)
    }
}

// extension PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate
extension ViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    func presentLoginViewController() {
        let loginViewController = PFLogInViewController()
        let signUPViewController = PFSignUpViewController()
        
        loginViewController.delegate = self
        signUPViewController.delegate = self
        
        loginViewController.fields = [.usernameAndPassword, .logInButton, .signUpButton]
        loginViewController.signUpController = signUPViewController
        
        present(loginViewController, animated: true, completion: nil)
    }
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        //トップ画面に行く
        logInController.dismiss(animated: true, completion: nil)
    }
    
    func signUpViewController(_ signUpController: PFSignUpViewController, didSignUp user: PFUser) {
        signUpController.dismiss(animated: true, completion: nil)
    }
}

