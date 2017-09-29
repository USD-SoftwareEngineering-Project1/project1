//
//  RoundedButton.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/20/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class RoundedButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
        
        layer.backgroundColor = GlobalActions.themeLightBlue
        layer.cornerRadius = layer.frame.height/2
        
        layer.shadowColor = GlobalActions.themeDarkBlue
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.8
        layer.masksToBounds = false
    }
}
