//
//  CommentTableViewCell.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/06.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var comment: Comment? {
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
        userProfileImage.layer.cornerRadius = userProfileImage.layer.bounds.width / 2
        userProfileImage.clipsToBounds = true
    }
    
    // MARK: Method
    private func updateUI() {
        userNameLabel.text = comment?.user.username
        createdAt.text = Utility.formatDate(date: comment!.createdAt!)
        commentLabel.text = comment?.commentText
        
        comment?.user.profileImageFile.getDataInBackground { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.userProfileImage.image = UIImage(data: imageData)
                }
            }
        }
    }
}
