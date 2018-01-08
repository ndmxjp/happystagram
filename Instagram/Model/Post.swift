//
//  Post.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/02.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Parse

public class Post: PFObject, PFSubclassing {

    //public API
    @NSManaged public var user: User
    @NSManaged public var postImageFile: PFFile
    @NSManaged public var postText: String
    @NSManaged public var numberOfLikes: Int
    @NSManaged public var likedUsrIDs: [String]

    override public init() {
        super.init()
    }
    
    init(user: User, postImage: UIImage, postText: String, numberOfLikes: Int) {
        super.init()

        self.postImageFile = createFileForm(image: postImage)
        self.user = user
        self.postText = postText
        self.numberOfLikes = numberOfLikes
        self.likedUsrIDs = [String]()

    }

    //PFSubclassing
    public static func parseClassName() -> String {
        return "Post"
    }
    
    // MARK: Method
    public func changeLike() {
        let currentUser = User.current()!
        if userDidLike(user: currentUser) {
            disLike()
        } else {
            like()
        }
    }
    
    private func like() {
        let currentUserID = User.current()?.objectId
        if !likedUsrIDs.contains(currentUserID!) {
            numberOfLikes += 1
            likedUsrIDs.insert(currentUserID!, at: 0)
            saveInBackground()
        }
    }
    
    private func disLike() {
        let currentUserID = User.current()?.objectId
        if likedUsrIDs.contains(currentUserID!) {
            numberOfLikes -= 1
            for (index, userID) in likedUsrIDs.enumerated() {
                if userID == currentUserID! {
                    likedUsrIDs.remove(at: index)
                    break
                }
            }
            saveInBackground()
        }
    }
    
    public func userDidLike(user :User) -> Bool {
        return likedUsrIDs.filter { (objectID) -> Bool in
            return user.objectId == objectID
        }.count > 0
    }
    
}
