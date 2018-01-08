//
//  PostTableViewCell.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/03.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Spring

protocol PostTableViewCellDelegate {
    func commentButtonClicked(post: Post)
}

class PostTableViewCell: UITableViewCell {

    // MARK: Outlet
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    
    var delegate: PostTableViewCellDelegate?
    // MARK: property
    var post: Post! {
        didSet{
            updateUI()
        }
    }
    
    private var currentUserDidLike = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: Method
    private func updateUI() {
        
        //画像を丸くする処理
        userProfileImage.layer.cornerRadius = userProfileImage.layer.bounds.width / 2
        postImage.layer.cornerRadius = 5.0
        
        userProfileImage.clipsToBounds = true
        postImage.clipsToBounds = true
        
        post.user.profileImageFile.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.userProfileImage.image = UIImage(data: imageData)
                }
            }
        })
        post.postImageFile.getDataInBackground { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.postImage.image = UIImage(data: imageData)
                }
            } else {
                print(error)
            }
        }
        userNameLabel.text = post.user.username
        createdAt.text = Utility.formatDate(date: post.createdAt!)
        postText.text = post.postText
        
        likeButton.setTitle("\(post.numberOfLikes) Likes", for: .normal)
        
        configureButtonAppearance()
        applyLikeButtonColor()
    }
    
    private func configureButtonAppearance() {
        likeButton.layer.cornerRadius = 3.0
        likeButton.layer.borderWidth = 2.0
        likeButton.layer.borderColor = UIColor.lightGray.cgColor
        likeButton.tintColor = UIColor.lightGray
        
        commentButton.layer.cornerRadius = 3.0
        commentButton.layer.borderWidth = 2.0
        commentButton.layer.borderColor = UIColor.lightGray.cgColor
        commentButton.tintColor = UIColor.lightGray
    }
    
    private func applyLikeButtonColor() {
        if post.userDidLike(user: User.current()!) {
            likeButton.layer.borderColor = #colorLiteral(red: 0.7254901961, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
            likeButton.tintColor = #colorLiteral(red: 0.7254901961, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        } else {
            likeButton.layer.borderColor = UIColor.lightGray.cgColor
            likeButton.tintColor = UIColor.lightGray
        }
    }
    
    // MARK: IBAction
    
    @IBAction func likeButtonTapAction(_ sender: DesignableButton) {
        post.changeLike()
        
        likeButton.setTitle("\(post.numberOfLikes) Likes", for: .normal)

        applyLikeButtonColor()
        //animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
    }
    
    @IBAction func commentButtonTapAction(_ sender: DesignableButton) {
        //animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()
        
        delegate?.commentButtonClicked(post: post)
    }
    
}
