//
//  AuthService.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/20/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    
    private static let _singleton = AuthService()
    static var singleton: AuthService{
        return _singleton
    }
    
    
    func createAccount(sender: UIViewController, email: String, password: String, completed: @escaping () -> ()){
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error == nil{
                if user != nil{
                    print("no error, user")
                }else{
                    GlobalActions.singleton.displayAlert(sender: sender, title: "Authentication Error", message: "User not authenticated")
                    print("no error, no user")
                }
            }else{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Error on Account Creation", message: "\(error!.localizedDescription)")
                print("error")
                //self.handleFirebaseErrors(error: error!)
            }
            completed()
        })
    }

    func signIn(sender: UIViewController, email: String, password: String, completed: @escaping (Bool, String) -> ()){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Login Error", message: error!.localizedDescription)
                completed(false, error!.localizedDescription)
            }
            if user == nil{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Login Error", message: "Username / password combination incorrect")
                completed(false, "authentication error")
            }
            if error == nil && user != nil{
                completed(true, "success")
            }
        })
    }
    
 
    func forgotPassword(sender: UIViewController, email: String){
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error != nil{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Password recovery error", message: "Error sending password reset email. Check that your email address is entered correctly in the \"email\" field")
            }
        }
    }
    
    func signOut(sender: UIViewController){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            sender.dismiss(animated: true, completion: nil)
        }catch let signOutError as NSError {
            GlobalActions.singleton.displayAlert(sender: sender, title: "Log out Error", message: "\(signOutError.localizedDescription)")
            return
        }
        
    }
    
    func handleFirebaseErrors(error: Error){
        
    }
    
    
}
