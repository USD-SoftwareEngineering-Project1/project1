//
//  PopUpSelectionCell.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/21/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class PopUpSelectionCell: UITableViewCell{
    
    var tapAction: ((UITableViewCell) -> Void)?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var selectButton: UIButton!
    
    @IBAction func selectButtonPressed(_ sender: Any) {
        tapAction?(self)
    }
    
    func configureCell(data: String, selected: Bool){
        self.titleLabel.text = data
        
        if selected == false{
            selectButton.setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank"), for: .normal)
        }else{
            selectButton.setImage(#imageLiteral(resourceName: "ic_check_box"), for: .normal)
        }
    }
}
