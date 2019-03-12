//
//  CommentCell.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/11/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
    } // end awakeFromNib function
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
    } // end setSelected function
    
} // end CommentCell class
