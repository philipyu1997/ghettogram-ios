//
//  PostCell.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/7/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    // Outlets
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    } // end awakeFromNib function

    override func setSelected(_ selected: Bool, animated: Bool) {
     
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    } // end setSelected function

} // end PostCell classj
