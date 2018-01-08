//
//  User.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/07.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import UIKit
import Parse

public class User: PFUser /*, PFSubclassing */{
    
    @NSManaged public var profileImageFile: PFFile
    
    func updateProfileImage(image: UIImage) {
        self.profileImageFile = createFileForm(image: image)
        saveInBackground()
    }
}
