//
//  NewIdeaVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewIdeaVC: UIViewController, UITextFieldDelegate, UITextViewDelegate, PopUpSenderDelegate{
    var selectedMajors = [PopUpSelectionData]()

    var user: UserData!
    var firebaseUser: User!
    var userDataFilled: Bool! = false
    var roles: [String] = ["Any"]
    
    //MARK: PopUpSenderDelegate
    func dataTransfer(majors: [PopUpSelectionData]) {
        self.selectedMajors = majors
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTapToDismissKeyboard()
        configureTextFields()
        
        firebaseUser = Auth.auth().currentUser
        DataService.singleton.observeUser(uid: firebaseUser.uid, completed: {(user) in
            self.user = user
            self.userDataFilled = true
        })
    }
    
    @IBOutlet var ideaTitleTextField: RoundedTextField!
    @IBOutlet var ideaSubtitleTextField: RoundedTextView!
    @IBOutlet var ideaDescriptionTextField: RoundedTextView!
    
    @IBAction func selectRolesButtonPressed(_ sender: Any) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
        
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, aboveSubview: ideaTitleTextField)
        performSegue(withIdentifier: "SelectMajors", sender: nil)
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        
        var selectedMajorStringArray = [String]()
        for selectedMajor in selectedMajors{
            selectedMajorStringArray.append(selectedMajor.title)
        }
        
        if userDataFilled == false{
            GlobalActions.singleton.displayAlert(sender: self, title: "Timing Error", message: "Wait for userData to be filled")
            return
        }
        let ideaReference = UUID().uuidString
        let ideaTitle = ideaTitleTextField.text!
        let ideaSubtitle = ideaSubtitleTextField.text!
        let ideaDescription = ideaDescriptionTextField.text!
        
        
        
        let idea = IdeaData(ideaReference: ideaReference, ideaTitle: ideaTitle, ideaSubtitle: ideaSubtitle, ideaDescription: ideaDescription, roles: selectedMajorStringArray, ideaAuthorUID: self.user.userUID, ideaAuthorName: self.user.name, ideaAuthorMajor: self.user.major, timestamp: Date().timeIntervalSince1970)
        
        DataService.singleton.submitNewIdea(idea: idea)
        self.navigationController?.popViewController(animated: true)

    }
    
    func configureTextFields(){
        ideaTitleTextField.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.2)
        
        ideaTitleTextField.placeholder = "Idea Title"
        ideaSubtitleTextField.text = "Subtitle"
        ideaDescriptionTextField.text = "Description"
        
        ideaSubtitleTextField.textColor = UIColor.gray
        ideaDescriptionTextField.textColor = UIColor.gray
        
        
        ideaTitleTextField.delegate = self
        ideaSubtitleTextField.delegate = self
        ideaDescriptionTextField.delegate = self
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
