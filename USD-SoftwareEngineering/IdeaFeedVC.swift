//
//  IdeaFeedVC.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/19/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class IdeaFeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate{
    
    var firebaseUser: User!
    var ideas = [IdeaData]()
    var filteredIdeas = [IdeaData]()
    var searchActive = false
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()

    
    //MARK: Init
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firebaseUser = Auth.auth().currentUser
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.estimatedRowHeight = 75.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.addSubview(self.refreshControl)
        
        self.searchBar.delegate = self
        
        DataService.singleton.observeIdeas(completed: { (ideas) in
            self.ideas = ideas
            self.tableView.reloadData()
        })
    }
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBAction func profileButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowMyProfile", sender: firebaseUser.uid)
    }
    @IBAction func allUsersButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ShowAllUsers", sender: nil)
    }
    @IBOutlet var tableView: UITableView!
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        DataService.singleton.observeIdeas(completed: { (ideas) in
            self.ideas = ideas
            self.tableView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IdeaCell", for: indexPath)
        if searchActive{
            cell.textLabel?.text = filteredIdeas[indexPath.row].ideaTitle
            cell.detailTextLabel?.text = filteredIdeas[indexPath.row].ideaSubtitle

        }else{
            cell.textLabel?.text = ideas[indexPath.row].ideaTitle
            cell.detailTextLabel?.text = ideas[indexPath.row].ideaSubtitle
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return filteredIdeas.count
        }else{
            return ideas.count
        }
    }
    
    //Allow user to delete their own idea
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(searchActive){
            if editingStyle == .delete{
                if(filteredIdeas[indexPath.row].ideaAuthorUID == firebaseUser.uid){
                    DataService.singleton.deleteIdea(userUID: firebaseUser.uid, ideaReference: filteredIdeas[indexPath.row].ideaReference)
                    self.filteredIdeas.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }else{
            if editingStyle == .delete{
                if(ideas[indexPath.row].ideaAuthorUID == firebaseUser.uid){
                    DataService.singleton.deleteIdea(userUID: firebaseUser.uid, ideaReference: ideas[indexPath.row].ideaReference)
                    self.ideas.remove(at: indexPath.row)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchActive{
            performSegue(withIdentifier: "IdeaSelected", sender: filteredIdeas[indexPath.row])
        }else{
            performSegue(withIdentifier: "IdeaSelected", sender: ideas[indexPath.row])
        }
    }
    
    //MARK: SearchBar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredIdeas = ideas.filter({ (text) -> Bool in
            let ideaTitle: NSString = text.ideaTitle as NSString
            let ideaSubtitle: NSString = text.ideaSubtitle as NSString
            let ideaDescription: NSString = text.ideaDescription as NSString
            //let roles: NSString = text.roles as NSString
            
            let ideaTitleRange = ideaTitle.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let ideaSubtitleRange = ideaSubtitle.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let ideaDescriptionRange = ideaDescription.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            //let roles = roles.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            
            return ideaTitleRange.location != NSNotFound || ideaSubtitleRange.location != NSNotFound || ideaDescriptionRange.location != NSNotFound  /*|| rolesRange.location != NSNotFound*/
        })
        if(filteredIdeas.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.tableView.estimatedRowHeight = 75.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.reloadData()
    }
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "IdeaSelected"{
            let dest = segue.destination as! IdeaDetailsVC
            dest.ideaReference = (sender as! IdeaData).ideaReference
        }
        if segue.identifier == "ShowMyProfile"{
            let dest = segue.destination as! ProfileVC
            dest.userUID = sender as! String
        }
    }
    
    //MARK: Close
    override func viewWillAppear(_ animated: Bool) {
        searchActive = false
    }
}
