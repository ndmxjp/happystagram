//
//  SettingViewController.swift
//  Instagram
//
//  Created by saito-takumi on 2018/01/08.
//  Copyright © 2018年 saito-takumi. All rights reserved.
//

import Foundation
import UIKit
import ImagePicker
import RSKImageCropper

class SettingViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    let imagePickerController = ImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = 1
        
        User.current()?.profileImageFile.getDataInBackground(block: { (imageData, error) in
            if error == nil {
                if let imageData = imageData {
                    self.profileImage.image = UIImage(data: imageData)
                }
            }
        })

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImage.layer.cornerRadius = profileImage.layer.bounds.width / 2
        profileImage.clipsToBounds = true
        logoutButton.layer.cornerRadius = 5.0
    }
    
    // MARK: IBAction
    @IBAction func tapChangeImageAction(_ sender: Any) {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func tapLogoutButtonAction(_ sender: Any) {
        User.logOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
}


// MARK: ImagePickerDelegate
extension SettingViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        
    }
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        let imageCropVC = RSKImageCropViewController(image: images.first!, cropMode: .circle)
        imageCropVC.delegate = self
        dismiss(animated: true) {
            self.present(imageCropVC, animated: false, completion: nil)
        }
        
    }
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: RSKImageCropViewControllerDelegate
extension SettingViewController: RSKImageCropViewControllerDelegate {
    func imageCropViewControllerDidCancelCrop(_ controller: RSKImageCropViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imageCropViewController(_ controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect, rotationAngle: CGFloat) {
        profileImage.image = croppedImage
        User.current()?.updateProfileImage(image: croppedImage)
        dismiss(animated: true, completion: nil)
    }
}
