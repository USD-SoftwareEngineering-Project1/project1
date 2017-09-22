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

class ProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var userUID: String!
    var user: UserData!
    var userIdeas =  [IdeaData]()
    var firebaseUser: User!

    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        
        firebaseUser = Auth.auth().currentUser

        
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
    @IBOutlet var profileImage: CircleView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var majorLabel: UILabel!
    @IBOutlet var emailButton: UIButton!
    @IBAction func emailButtonPressed(_ sender: Any) {
    }
    @IBOutlet var bioLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
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
    }
}
