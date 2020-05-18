//
//  ProfileDetailsViewController.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/12/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class ProfileDetailsViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var profileViewImage: UIImageView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        submitButton.makeRounded(withRadius: 8)
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func onDismissButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
        let user = PFUser.current()
        
        let imageData = profileViewImage.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        user?["image"] = file
        
        user?.saveInBackground { (success, error) in
            if success {
                print("SUCCESS: Successfully updated your profile image!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("Error: \(String(describing: error))")
            }
        }
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .photoLibrary
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
}

extension ProfileDetailsViewController: UIImagePickerControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Section
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        profileViewImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
