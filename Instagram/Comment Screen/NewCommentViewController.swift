//
//  ViewController.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/07.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Parse

class NewCommentViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentText: UITextView!
    
//    var user = User.allUsers()[0]
    var user = User.current()
    var post: Post!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor as NSAttributedStringKey: UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1019607843, green: 0.137254902, blue: 0.4941176471, alpha: 1)
        
        commentText.text = ""
        commentText.becomeFirstResponder()
        
//        profileImage.image = user.profileImage
        userNameLabel.text = User.current()?.username
        
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width / 2
        profileImage.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK : IBAction
    @IBAction func backButtonTapAction(_ sender: Any) {
        commentText.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentButtonTapAction(_ sender: Any) {
        postNewComment()
        commentText.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Method
    func postNewComment() {
        let newComment = Comment(postID: post.objectId!, user: User.current()!, commentText: commentText.text)
        newComment.saveInBackground { (success, error) in
            if error == nil {
                print("comment sent")
                // local notification
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name.newCommentSent, object: nil, userInfo: ["newCommentObject": newComment])
                center.post(notification)
            } else {
                print(error)
            }
        }
    }
}
