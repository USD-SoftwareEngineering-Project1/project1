//
//  RoundedTextField.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/20/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class RoundedTextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        
        layer.cornerRadius = 15.0
        
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.75)
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor(red: 18.0/255.0, green: 118.0/255.0, blue: 197.0/255.0, alpha: 1.0)])
        
        self.textColor = UIColor.black
    }
    
}
