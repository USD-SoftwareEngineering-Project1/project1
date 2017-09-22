//
//  GlobalActions.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/20/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//
//
//  GlobalActions.swift
//  Youth-Development-Dialogue
//
//  Created by Lily Hofman on 7/31/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class GlobalActions{
    private static let _singleton = GlobalActions()
    static var singleton: GlobalActions{
        return _singleton
    }
    static let themeLightBlue = UIColor(red: 18.0/255.0, green: 118.0/255.0, blue: 197.0/255.0, alpha: 1.0).cgColor
    static let themeDarkBlue = UIColor(red: 5.0/255.0, green: 60.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
    
    func displayAlert(sender: UIViewController, title: String, message: String){
        
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAlert = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        errorAlert.addAction(dismissAlert)
        sender.present(errorAlert, animated: true, completion: nil)
    }
    
    //Returns an image given a url for that image
    func getImage(from mediaURL: String) -> UIImage{
        if let url = URL(string: mediaURL){
            if let data = NSData(contentsOf: url){
                let image = UIImage(data: data as Data)
                if image != nil{
                    return image!
                }
            }
        }
        return #imageLiteral(resourceName: "network-rect")
    }
    
}
