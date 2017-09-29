//
//  ProfileVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageUI

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate{
    //userUID required to set up page - passed in via segue
    var userUID: String!
    
    //User data to be filled in via firebase call
    var user: UserData!
    var userIdeas =  [IdeaData]()
    var firebaseUser: User!

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self

        firebaseUser = Auth.auth().currentUser
        
        if userUID != firebaseUser.uid{
            settingsButton.isEnabled = false
            settingsButton.image = nil
        }
        
        
        DataService.singleton.observeUser(uid: userUID, completed: { (user) in
            self.user = user
            self.userIdeas = user.ideas!
            self.nameLabel.text = user.name
            self.majorLabel.text = user.major.joined(separator: " & ")
            self.emailButton.setTitle(user.email, for: .normal)
            self.bioLabel.text = user.bio
            
            self.tableView.reloadData()
        })
        
    }
    @IBOutlet var settingsButton: UIBarButtonItem!
    @IBOutlet var profileImage: CircleView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var emailButton: UIButton!
    @IBAction func emailButtonPressed(_ sender: Any) {
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([user.email])
        
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            GlobalActions.singleton.displayAlert(sender: self, title: "Error sending message", message: "Your device could not send an e-mail to \(user.email).  Please check your device's e-mail configuration and try again.")
        }
    }
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "Settings", sender: userUID)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserIdeasCell", for: indexPath)
        cell.textLabel?.text = userIdeas[indexPath.row].ideaTitle
        cell.detailTextLabel?.text = userIdeas[indexPath.row].ideaSubtitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userIdeas.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewUsersIdeaDetails", sender: userIdeas[indexPath.row].ideaReference)

    }
    //Allow user to delete their own idea
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if(userIdeas[indexPath.row].ideaAuthorUID == firebaseUser.uid){
                DataService.singleton.deleteIdea(userUID: firebaseUser.uid, ideaReference: userIdeas[indexPath.row].ideaReference)
                self.userIdeas.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewUsersIdeaDetails"{
            let dest = segue.destination as! IdeaDetailsVC
            dest.ideaReference = sender as! String
        }
        if segue.identifier == "Settings"{
            let dest = segue.destination as! UserProfileSettingsVC
            dest.userUID = sender as! String
            dest.user = self.user
        }
    }
    // MARK: MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
