//
//  PostInCommentTableViewCell.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/06.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Spring

class PostInCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postText: UILabel!
    @IBOutlet weak var likeButton: DesignableButton!
    
    var post: Post? {
        didSet {
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width / 2
        profileImage.clipsToBounds = true
        
        postImage.layer.cornerRadius = 5.0
    }
    
    // MARK: method
    private func updateUI() {
        userNameLabel.text = post?.user.username
        createdAt.text = Utility.formatDate(date: post!.createdAt!)
        
        post?.user.profileImageFile.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.profileImage.image = UIImage(data: imageData)
                }
            }
        })
        
        post?.postImageFile.getDataInBackground { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.postImage.image = UIImage(data: imageData)
                }
            } else {
                print(error)
            }
        }
        postText.text = post?.postText

        likeButton.setTitle("\(post!.numberOfLikes) Likes", for: .normal)

        applyLikeButtonColor()
        configureButtonAppearance()
    }
    
    private func applyLikeButtonColor() {
        if post!.userDidLike(user: User.current()!) {
            likeButton.layer.borderColor = #colorLiteral(red: 0.7254901961, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
            likeButton.tintColor = #colorLiteral(red: 0.7254901961, green: 0.2509803922, blue: 0.2784313725, alpha: 1)
        } else {
            likeButton.layer.borderColor = UIColor.lightGray.cgColor
            likeButton.tintColor = UIColor.lightGray
        }
    }
    
    private func configureButtonAppearance() {
        likeButton.layer.cornerRadius = 3.0
        likeButton.layer.borderWidth = 2.0
        likeButton.layer.borderColor = UIColor.lightGray.cgColor
        likeButton.tintColor = UIColor.lightGray
        
    }

    
    // MARK : IBAction
    @IBAction func likeButtonTapAction(_ sender: DesignableButton) {
        post?.changeLike()
        likeButton.setTitle("\(post!.numberOfLikes) Likes", for: .normal)

        applyLikeButtonColor()
        //animation
        sender.animation = "pop"
        sender.curve = "spring"
        sender.duration = 1.5
        sender.damping = 0.1
        sender.velocity = 0.2
        sender.animate()

    }
    
    
}
