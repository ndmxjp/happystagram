//
//  PostViewController.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/03.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker
import Photos
import Spring
import Parse

class PostViewController: UIViewController {
    
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var postText: UITextView!
    @IBOutlet weak var postImage: DesignableImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAt: UILabel!

    var selectedPostImage: UIImage?

    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor as NSAttributedStringKey: UIColor.white]
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1019607843, green: 0.137254902, blue: 0.4941176471, alpha: 1)

        userProfileImage.layer.cornerRadius = userProfileImage.bounds.width / 2.0
        userProfileImage.clipsToBounds = true
        
        User.current()?.profileImageFile.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.userProfileImage.image = UIImage(data: imageData)
                }
            }
        })
        
        userNameLabel.text = User.current()?.username!
        
        postText.text = ""
        postText.becomeFirstResponder()
        
        // Notification Center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: IBAction
    
    @IBAction func backButtonTapAction(_ sender: Any) {
        postText.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func postButtonTapAction(_ sender: Any) {
        
        if selectedPostImage == nil {
            shakeImageView()
        } else if postText.text.isEmpty {
            
        } else {
            createNewPost()
            postText.resignFirstResponder()
            dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func tapCameeraAction(_ sender: Any) {
        let authorization = PHPhotoLibrary.authorizationStatus()
        if authorization == .notDetermined {
            PHPhotoLibrary.requestAuthorization({ (status) in

            })
        } else {
            let imagePickerController = ImagePickerController()
            imagePickerController.imageLimit = 1
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    // MARK: Method
    @objc func keyboardWillHide(notification: Notification) {
        
        self.postText.contentInset = UIEdgeInsets.zero
        self.postText.scrollIndicatorInsets = UIEdgeInsets.zero
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue.height
        self.postText.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize + 15.0, right: 0)
        self.postText.scrollIndicatorInsets = postText.contentInset
    }
    
    func createNewPost() {
        let newPost = Post(user: User.current()!, postImage: selectedPostImage!, postText: postText.text, numberOfLikes: 0)
        
        newPost.saveInBackground { (success, error) in
            if error == nil {
                print("post saved")
                
                //local notificatioin
                let center = NotificationCenter.default
                let notification = Notification(name: Notification.Name.newPostCreated, object: nil, userInfo: ["newPostObject": newPost])
                center.post(notification)
            } else {
                print(error)
            }
        }
    }
    

    func shakeImageView() {
        postImage.animation = "shake"
        postImage.curve = "spring"
        postImage.duration = 1.0
        postImage.animate()
    }
}

// MARK: UIImagePickerViewDelegate
extension PostViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]){
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        dismiss(animated: true) {
            self.selectedPostImage = images.first
            self.postImage.image = self.selectedPostImage
        }
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

}
