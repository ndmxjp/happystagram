//
//  CommentViewController.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/06.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import Foundation
import UIKit
import Floaty
import Parse

class CommentViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var post: Post?
    
    var comments = [Comment]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor as NSAttributedStringKey: UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1019607843, green: 0.137254902, blue: 0.4941176471, alpha: 1)
        
        let postNib = UINib(nibName: "PostInCommentTableViewCell", bundle: nil)
        tableView.register(postNib, forCellReuseIdentifier: "postInCommentCell")
        
        let commentNib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        tableView.register(commentNib, forCellReuseIdentifier: "commentCell")
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.dataSource = self
        
        let floaty = Floaty()
        floaty.fabDelegate = self
        self.view.addSubview(floaty)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchComment()
        let center = NotificationCenter.default
        center.addObserver(forName: Notification.Name.newCommentSent, object: nil, queue: OperationQueue.main) { (notification) in
            if let newComment = notification.userInfo?["newCommentObject"] as? Comment {
                if !self.postWasDisplayed(newComment: newComment) {
                    self.comments.insert(newComment, at: self.comments.count)
                }
            }
        }
    }
    
    // MARK: Method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "new comment composer" {
            let navigationController = segue.destination as! UINavigationController
            let newCommentViewController = navigationController.childViewControllers.first as! NewCommentViewController
            newCommentViewController.post = post
        }
    }
    
    func postWasDisplayed(newComment: Comment) -> Bool {
        return self.comments.contains(newComment)
    }
    
    func fetchComment() {
        let commentQuery = PFQuery(className: Comment.parseClassName())
        commentQuery.whereKey("postID", equalTo: post?.objectId)
        commentQuery.order(byAscending: "updatedAt")
        commentQuery.cachePolicy = .cacheThenNetwork
        commentQuery.includeKey("user")
        commentQuery.findObjectsInBackground { (objects, error) in
            if error == nil {
                if let objects = objects {
                    if objects.count > 0 {
                        self.comments = objects.map({ (pfObject) -> Comment in
                            return pfObject as! Comment
                        })
                    }
                }
            } else {
                print(error)
            }
        }
    }
}

// MARK: UITableViewDataSource
extension CommentViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postInCommentCell", for: indexPath) as! PostInCommentTableViewCell
            cell.post = post
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
            cell.comment = comments[indexPath.row-1]
            return cell
        }
    }
}

// MARK: FloatyDelegate
extension CommentViewController: FloatyDelegate {
    
    func emptyFloatySelected(_ floaty: Floaty){
        print("tapped")
        self.performSegue(withIdentifier: "new comment composer", sender: self)
    }
}

