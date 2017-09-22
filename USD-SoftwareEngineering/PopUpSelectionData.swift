//
//  PopUpSelectionData.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/20/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit


class PopUpSelectionData{
    private var _title: String!
    private var _selected: Bool!
    
    var title: String{
        get{
            return _title
        }set{
            _title = newValue
        }
    }
    
    var selected: Bool{
        get{
            return _selected
        }set{
            _selected = newValue
        }
    }
    init(title: String, selected: Bool){
        self.title = title
        self.selected = selected
    }
    
}
