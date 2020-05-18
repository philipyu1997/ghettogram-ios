//
//  ProfileViewController.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/12/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var editProfileButton: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        editProfileButton.makeRounded(withRadius: 8)
        
        // Set profile image
        let profileImage = PFUser.current()!["image"] as? PFFileObject
        
        profileImage?.getDataInBackground(block: { (success, error) in
            if success != nil, error == nil {
                let image = UIImage(data: success!)
                
                self.profileImageView.image = image
                self.profileImageView.makeRounded(withRadius: 100)
            } else {
                print("Error: \(String(describing: error))")
            }
        })
        
    }
    
}
