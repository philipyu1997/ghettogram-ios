//
//  ProfileDetailsViewController.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/12/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class ProfileDetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var profileViewImage: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    } // end viewDidLoad function
    
    @IBAction func dismissButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    } // end dismissButton function
    
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
                print("ERROR: Failed to update profile image!")
            }
        }
        
    } // end onSubmitButton function
    
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
        
    } // end onCameraButton function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageAspectScaled(toFill: size)
        
        profileViewImage.image = scaledImage
        
        dismiss(animated: true, completion: nil)
        
    } // end imagePickerController function
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
} // end ProfileDetailsViewController class
