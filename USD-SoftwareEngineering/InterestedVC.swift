//
//  InterestedVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class InterestedUsersVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var interestedUsers: [UserData]!
    var ideaReference: String!

    @IBOutlet var rootView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        rootView.layer.cornerRadius = 15.0
        rootView.layer.masksToBounds = true
        
    }
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interestedUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        
        cell.textLabel?.text = interestedUsers[indexPath.row].name
        cell.detailTextLabel?.text = interestedUsers[indexPath.row].major.joined(separator: " & ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewUser", sender: interestedUsers[indexPath.row].userUID )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewUser"{
            let destVC = segue.destination as! ProfileVC
            destVC.userUID = sender as! String
        }
    }
}
