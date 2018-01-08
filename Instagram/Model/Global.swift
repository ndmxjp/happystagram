//
//  Global.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/07.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import Foundation
import Parse
import UIKit

extension Notification.Name {
    static let newPostCreated = Notification.Name("newPostCreated")
    static let newCommentSent = Notification.Name("newCommentSent")
}

class Utility {
    static func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-US")
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter.string(from: date)
    }
}

struct ImageSize {
    static let height: CGFloat = 480
}

func createFileForm(image: UIImage) -> PFFile {
    
    let ratio = image.size.width / image.size.height
    let resizedImage = resizeImage(image, toWidth: ImageSize.height * ratio, andHeight: ImageSize.height)
    let imageData = UIImageJPEGRepresentation(resizedImage, 0.8)
    
    return PFFile(name: "image.jpg", data: imageData!)!
}

func resizeImage(_ originalImage: UIImage, toWidth width: CGFloat, andHeight height: CGFloat) -> UIImage {
    let newSize = CGSize(width: width, height: height)
    let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
    UIGraphicsBeginImageContext(newSize)
    originalImage.draw(in: newRectangle)
    
    let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return resizedImage!
}
