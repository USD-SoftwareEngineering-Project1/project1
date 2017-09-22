//
//  NewAccountVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewAccountVC: UIViewController, PopUpSenderDelegate{

    var selectedMajors = [PopUpSelectionData]()

    //MARK: PopUpSenderDelegate
    func dataTransfer(majors: [PopUpSelectionData]) {
        self.selectedMajors = majors
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectMajorsButton.layer.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.5).cgColor
        addTapToDismissKeyboard()
    }
    
    @IBOutlet var firstNameTextField: RoundedTextField!
    @IBOutlet var lastNameTextField: RoundedTextField!
    @IBOutlet var emailTextField: RoundedTextField!
    @IBOutlet var passwordTextField: RoundedTextField!
    @IBOutlet var selectMajorsButton: UIButton!
    @IBAction func selectMajorsButtonTapped(_ sender: Any) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
        
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, aboveSubview: firstNameTextField)
        performSegue(withIdentifier: "SelectMajors", sender: nil)
    }

    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
        var selectedMajorStringArray = [String]()
        for selectedMajor in selectedMajors{
            selectedMajorStringArray.append(selectedMajor.title)
        }
        
        //Authenticate user in firebase
        AuthService.singleton.createAccount(sender: self, email: emailTextField.text!, password: passwordTextField.text!){
            
            //Grab newly created user's auth id
            let firebaseUser: User = Auth.auth().currentUser!
            
            //Create new user object
            let newUser = UserData(userUID: firebaseUser.uid, firstName: self.firstNameTextField.text!, lastName: self.lastNameTextField.text!, email: self.emailTextField.text!, major: selectedMajorStringArray, bio: "About me: ")
            
            //Add new user to firebase database
            DataService.singleton.createUser(user: newUser){
                self.performSegue(withIdentifier: "UserCreated", sender: nil)
            }
        }
    }

    //Add tap to dismiss keyboard functionality
    func addTapToDismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SelectMajors"{
            let destVC = segue.destination as! MajorSelectionVC
            destVC.delegate = self
            destVC.presentingVC = self
            destVC.dataToDisplay = ["Major 1", "Major 2", "Major 3", "Major 4"]
        }
    }
}
