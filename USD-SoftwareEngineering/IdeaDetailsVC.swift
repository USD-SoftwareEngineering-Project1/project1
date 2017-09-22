//
//  IdeaDetailsVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class IdeaDetailsVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var ideaReference: String!
    var idea: IdeaData!
    var ideaComments = [IdeaCommentData]()
    var interestedUsers: [UserData]!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ideaDescriptionLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.addSubview(self.refreshControl)


        DataService.singleton.observeIdea(ideaReference: ideaReference, completed: {(idea) in
            self.idea = idea
            self.ideaComments = idea.comments!

            self.interestedUsers = idea.interestedUsers
            
            self.ideaTitleLabel.text = idea.ideaTitle
            self.ideaDescriptionLabel.text = idea.ideaDescription
            self.ideaAuthorNameButton.setTitle(idea.ideaAuthorName, for: .normal)
            
            self.tableView.reloadData()
        })
    }

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var ideaTitleLabel: UILabel!
    @IBOutlet var ideaDescriptionLabel: UILabel!
    @IBOutlet var descriptionLabelScrollView: UIScrollView!
    @IBOutlet var ideaAuthorNameButton: UIButton!
    @IBAction func ideaAuthorNameButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowAuthorProfile", sender: idea.ideaAuthorUID)
    }
    @IBAction func interestedButtonPressed(_ sender: Any) {
    }
    @IBAction func commentButtonPressed(_ sender: Any) {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.regular))
        
        blurEffectView.frame = self.view.frame
        
        self.view.insertSubview(blurEffectView, aboveSubview: ideaTitleLabel)
        performSegue(withIdentifier: "Comment", sender: idea.ideaReference)
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        DataService.singleton.observeIdea(ideaReference: ideaReference, completed: {(idea) in
            self.idea = idea
            self.ideaComments = idea.comments!
            self.interestedUsers = idea.interestedUsers
            
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ideaComments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath)
        cell.textLabel?.text! = ideaComments[indexPath.row].ideaCommentAuthorName
        cell.detailTextLabel?.text! = ideaComments[indexPath.row].ideaCommentText
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Comment"{
            let dest = segue.destination as! CommentVC
            dest.ideaReference = sender as! String
            dest.presentingVC = self
        }
        if segue.identifier == "ShowAuthorProfile"{
            let dest = segue.destination as! ProfileVC
            dest.userUID = sender as! String
        }
    }
    
}
