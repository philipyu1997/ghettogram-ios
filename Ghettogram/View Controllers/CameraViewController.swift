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

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    } // end viewDidLoad function
    
    @IBAction func onSubmitButton(_ sender: Any) {
        
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = photoImageView.image!.pngData()
        let file = PFFileObject(data: imageData!)
        
        post["image"] = file
        
        post.saveInBackground { (success, error) in
            if success {
                print("saved!")
                self.dismiss(animated: true, completion: nil)
            } else {
                print("error!")
            }
        }
        
    } // end onSubmitButton function
    
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
        
    } // end onCameraButton function
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[.editedImage] as! UIImage
        let size = CGSize(width: 300, height: 300)
        let scaledImage = image.af_imageScaled(to: size)
        
        photoImageView.image = scaledImage
        
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
    
} // end CameraViewController class
