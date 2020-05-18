//
//  Constant.swift
//  Ghettogram
//
//  Created by Philip Yu on 5/17/20.
//  Copyright © 2020 Philip Yu. All rights reserved.
//

import UIKit

struct Constant {
    
    // MARK: - Properties
    static let applicationId = fetchFromPlist(forResource: "Parse", forKey: "APP_ID")
    static let server = fetchFromPlist(forResource: "Parse", forKey: "SERVER_URL")
    
    // MARK: - Functions
    static func fetchFromPlist(forResource resource: String, forKey key: String) -> String? {
        
        let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: key) as? String
        
        return value
        
    }
    
}

extension UIButton {
    
    func makeRounded(withRadius cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        
    }
    
}

extension UIImageView {
    
    func makeRounded(withRadius cornerRadius: CGFloat) {
        
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        
    }
    
}
