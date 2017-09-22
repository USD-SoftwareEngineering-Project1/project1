//
//  LoginVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapToDismissKeyboard()
    }
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    @IBAction func signInButtonPressed(_ sender: Any) {
        if (emailTextField.text == nil || emailTextField.text == "" || passwordTextField.text == nil || passwordTextField.text == ""){
            GlobalActions.singleton.displayAlert(sender: self, title: "Insufficient Information", message: "Please enter email and password")
            return
        }
        
        AuthService.singleton.signIn(sender: self, email: emailTextField.text!, password: passwordTextField.text!, completed: { (success, message) in
            if success{
                self.performSegue(withIdentifier: "SignIn", sender: nil)
            }else{
                GlobalActions.singleton.displayAlert(sender: self, title: "Login Error", message: message)
            }
        })
    }
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        AuthService.singleton.forgotPassword(sender: self, email: emailTextField.text!)
        GlobalActions.singleton.displayAlert(sender: self, title: "Success", message: "Password recovery email was sent to \(emailTextField.text!)")
    }
    
    //Add tap to dismiss keyboard functionality
    func addTapToDismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
