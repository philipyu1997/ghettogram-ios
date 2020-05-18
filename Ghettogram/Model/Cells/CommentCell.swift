//
//  CommentCell.swift
//  Ghettogram
//
//  Created by Philip Yu on 3/11/19.
//  Copyright © 2019 Philip Yu. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        userImageView.makeRounded(withRadius: 16)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
    }
    
}
