//
//  PostCell.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        userImageView.makeRounded(withRadius: 16)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
    }
    
}
