//
//  ProfileSettingsVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class UserProfileSettingsVC: UIViewController{
    var userUID: String!
    var user: UserData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userLastNameTextField.text = user.name
        userEmailTextField.text = user.email
        userBioTextView.text = user.bio
    }
    
    @IBOutlet var userProfileImage: CircleView!
    @IBOutlet var userLastNameTextField: RoundedTextField!
    @IBOutlet var userMajorButton: RoundedButton!
    @IBAction func userMajorButtonPressed(_ sender: Any) {
    }
    @IBOutlet var userEmailTextField: RoundedTextField!
    @IBOutlet var userBioTextView: RoundedTextView!
    @IBAction func submitButtonPressed(_ sender: Any) {
        var name = userLastNameTextField.text
        if name == nil{
            name = user.name
        }
        
        var email = userEmailTextField.text
        if email == nil{
            email = user.email
        }
        var bio = userBioTextView.text
        if bio == nil{
            bio = user.bio
        }
        DataService.singleton.updateUser(userUID: userUID, name: name!, email: email!, bio: bio!)
        dismiss(animated: true, completion: nil)
    }
    
}
