//
//  Comment.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/02.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Parse

public class Comment: PFObject, PFSubclassing{
    
    @NSManaged public var postID: String!
    @NSManaged public var user: User!
    @NSManaged public var commentText: String!

    var post: Post!

    override public init() {
        super.init()
    }

    init(postID: String, user: User, commentText: String) {
        super.init()
        
        self.postID = postID
        self.user = user
        self.commentText = commentText
    }

    //PFSubclassing
    public static func parseClassName() -> String {
        return "Comment"
    }    
}
