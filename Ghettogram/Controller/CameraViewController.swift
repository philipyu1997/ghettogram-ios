//
//  CameraViewController.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController, UINavigationControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        submitButton.makeRounded(withRadius: 8)
        
    }
    
    // MARK: - IBAction Section
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = photoImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, _) in
            if success {
                print("SUCCESS: Photo has been uploaded to your feed!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("ERROR: Failed to upload photo to your feed!")
            }
        }
        
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func dismissPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

extension CameraViewController: UIImagePickerControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate Section
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        photoImageView.image = scaledImage
        dismiss(animated: true, completion: nil)
        
    }
    
}
