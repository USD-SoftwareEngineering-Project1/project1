//
//  DataService.swift
//  USD-SoftwareEngineering
//
//  Created by Lily Hofman on 9/20/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()
let USERS = "Users"
let IDEAS = "Ideas"

class DataService{
    
    //MARK: DataService Singleton
    private static let _singleton = DataService()
    static var singleton: DataService{
        return _singleton
    }
    
    //MARK: Database Entry Points
    var firebaseIdeasRef: DatabaseReference{
        return DB_BASE.child(IDEAS)
    }
    
    var firebaseUsersRef: DatabaseReference{
        return DB_BASE.child(USERS)
    }
    
    //MARK: Storage Entry Points
    var firebaseProfilePhotoStorageRef: StorageReference{
        return STORAGE_BASE.child("ProfilePhotos")
    }
    
    //MARK: ---------------------
    //MARK: WRITING TO FIREBASE
    //MARK: ---------------------
    //Called from NewAccountVC
    func createUser(user: UserData, completed: @escaping () -> ()){
        let databaseUser: Dictionary<String, AnyObject> = [
            "uid": user.userUID as AnyObject,
            "email": user.email as AnyObject,
            "name": user.name as AnyObject,
            "majors": user.major as AnyObject,
            "bio": user.bio as AnyObject
            ]
        firebaseUsersRef.child(user.userUID).setValue(databaseUser)
        completed()
    }
    
    //Submits new idea to "Ideas" as well as "Users->Ideas"
    //Called from NewIdeaVC
    func submitNewIdea(idea: IdeaData){
        let newIdea: Dictionary<String, AnyObject> = [
            "ideaTitle": idea.ideaTitle as AnyObject,
            "ideaSubtitle": idea.ideaSubtitle as AnyObject,
            "ideaDescription": idea.ideaDescription as AnyObject,
            "ideaAuthorUID": idea.ideaAuthorUID as AnyObject,
            "ideaAuthorName": idea.ideaAuthorName as AnyObject,
            "ideaAuthorMajor": idea.ideaAuthorMajor as AnyObject,
            "timestamp": idea.timestamp as AnyObject,
            "rolesRequired": idea.roles as AnyObject
            ]
        firebaseIdeasRef.child(idea.ideaReference).setValue(newIdea)
        firebaseUsersRef.child(idea.ideaAuthorUID).child("Ideas").child(idea.ideaReference).setValue(newIdea)
    }
    
    //Called from CommentVC
    func submitComment(ideaReference: String, comment: IdeaCommentData){
        let newComment: Dictionary<String, AnyObject> = [
            "ideaCommentAuthorName": comment.ideaCommentAuthorName as AnyObject,
            "ideaCommentAuthorUID": comment.ideaCommentAuthorUID as AnyObject,
            "ideaCommentText": comment.ideaCommentText as AnyObject,
            "timestamp": comment.timestamp as AnyObject
        ]
        firebaseIdeasRef.child(ideaReference).child("comments").childByAutoId().setValue(newComment)
    }
    
    
    
    
    
    
    //MARK: ---------------------
    //MARK: READING FROM FIREBASE
    //MARK: ---------------------
    //Called from: IdeaFeedVC
    func observeIdeas(completed: @escaping ([IdeaData]) -> ()){
        var ideas = [IdeaData]()
        firebaseIdeasRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let ideaSnapshot = child as! DataSnapshot
                let ideaReference = ideaSnapshot.key
                let ideaTitle = ideaSnapshot.childSnapshot(forPath: "ideaTitle").value as! String
                let ideaSubtitle = ideaSnapshot.childSnapshot(forPath: "ideaSubtitle").value as! String
                let ideaDescription = ideaSnapshot.childSnapshot(forPath: "ideaDescription").value as! String
                let roles = ideaSnapshot.childSnapshot(forPath: "rolesRequired").value as! [String]
                let ideaAuthorUID = ideaSnapshot.childSnapshot(forPath: "ideaAuthorUID").value as! String
                let timestamp = ideaSnapshot.childSnapshot(forPath: "timestamp").value as! Double
                
                
                let idea = IdeaData(ideaReference: ideaReference, ideaTitle: ideaTitle, ideaSubtitle: ideaSubtitle, ideaDescription: ideaDescription, roles: roles, ideaAuthorUID: ideaAuthorUID, timestamp: timestamp)
                ideas.append(idea)
            }
            ideas.sort{
                $0.timestamp > $1.timestamp
            }
            completed(ideas)
        })
    }
    

    
    /*
    func observeIdeas(completed: @escaping ([IdeaData]) -> ()){
        var ideas = [IdeaData]()
        
        firebaseIdeasRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let ideaSnapshot = child as! DataSnapshot
                
                //Idea data
                let ideaReference = ideaSnapshot.key
                let ideaTitle = ideaSnapshot.childSnapshot(forPath: "ideaTitle").value as! String
                let ideaSubtitle = ideaSnapshot.childSnapshot(forPath: "ideaSubtitle").value as! String
                let ideaDescription = ideaSnapshot.childSnapshot(forPath: "ideaDescription").value as! String
                //let roles = ideaSnapshot.childSnapshot(forPath: "roles").value as! [String]
                let roles = ["temp1", "temp2"]
                
                //Author Data
                let ideaAuthorUID = ideaSnapshot.childSnapshot(forPath: "ideaAuthorUID").value as! String
                let ideaAuthorName = ideaSnapshot.childSnapshot(forPath: "ideaAuthorName").value as! String
                let ideaAuthorMajor = ideaSnapshot.childSnapshot(forPath: "ideaAuthorMajor").value as! [String]

                //Timing
                let timestamp = ideaSnapshot.childSnapshot(forPath: "timestamp").value as! Double
                
                //Feedback
                var commentData = [IdeaCommentData]()
                let comments = ideaSnapshot.childSnapshot(forPath: "comments")
                for child in comments.children{
                    let comment = child as! DataSnapshot
                    let ideaCommentAuthorName = comment.childSnapshot(forPath: "ideaCommentAuthorName").value as! String
                    let ideaCommentAuthorUID = comment.childSnapshot(forPath: "ideaCommentAuthorUID").value as! String
                    let ideaCommentText = comment.childSnapshot(forPath: "ideaCommentText").value as! String
                    let timestamp = comment.childSnapshot(forPath: "timestamp").value as! Double
                    
                    let newComment = IdeaCommentData(ideaCommentAuthorName: ideaCommentAuthorName, ideaCommentAuthorUID: ideaCommentAuthorUID, ideaCommentText: ideaCommentText, timestamp: timestamp)
                    commentData.append(newComment)
                }
                commentData.sort{
                    $0.timestamp > $1.timestamp
                }
                
                var interestedUsersData = [UserData]()
                let interestedUsers = ideaSnapshot.childSnapshot(forPath: "interestedUsers")
                for child in interestedUsers.children{
                    let user = child as! DataSnapshot
                    let userUID = user.childSnapshot(forPath: "uid").value as! String
                    let name = user.childSnapshot(forPath: "name").value as! String
                    let email = user.childSnapshot(forPath: "email").value as! String
                    let majors = user.childSnapshot(forPath: "majors").value as! [String]
                    
                    let newUser = UserData(userUID: userUID, name: name, email: email, major: majors)
                    interestedUsersData.append(newUser)
                }
                interestedUsersData.sort{
                    $0.name > $1.name
                }
                
                
                let newIdea = IdeaData(ideaReference: ideaReference, ideaTitle: ideaTitle, ideaSubtitle: ideaSubtitle, ideaDescription: ideaDescription, roles: roles, ideaAuthorUID: ideaAuthorUID, ideaAuthorName: ideaAuthorName, ideaAuthorMajor: ideaAuthorMajor, comments: commentData, interestedUsers: interestedUsersData, timestamp: timestamp)
                ideas.append(newIdea)

            }
            ideas.sort{
                $0.timestamp > $1.timestamp
            }
            completed(ideas)
        })
    }*/
    
    //Called from IdeaDetailsVC
    func observeIdea(ideaReference: String, completed: @escaping (IdeaData) -> ()){
        
        firebaseIdeasRef.child(ideaReference).observeSingleEvent(of: .value, with: { (snapshot) in
                let ideaSnapshot = snapshot
                let ideaReference = ideaSnapshot.key
                let ideaTitle = ideaSnapshot.childSnapshot(forPath: "ideaTitle").value as! String
                let ideaSubtitle = ideaSnapshot.childSnapshot(forPath: "ideaSubtitle").value as! String
                let ideaDescription = ideaSnapshot.childSnapshot(forPath: "ideaDescription").value as! String
                let roles = ideaSnapshot.childSnapshot(forPath: "rolesRequired").value as! [String]
            
                let ideaAuthorUID = ideaSnapshot.childSnapshot(forPath: "ideaAuthorUID").value as! String
                let ideaAuthorName = ideaSnapshot.childSnapshot(forPath: "ideaAuthorName").value as! String
                let ideaAuthorMajor = ideaSnapshot.childSnapshot(forPath: "ideaAuthorMajor").value as! [String]
                
                
                let timestamp = ideaSnapshot.childSnapshot(forPath: "timestamp").value as! Double
                
                var commentData = [IdeaCommentData]()
                let comments = ideaSnapshot.childSnapshot(forPath: "comments")
                for child in comments.children{
                    let comment = child as! DataSnapshot
                    let ideaCommentAuthorName = comment.childSnapshot(forPath: "ideaCommentAuthorName").value as! String
                    let ideaCommentAuthorUID = comment.childSnapshot(forPath: "ideaCommentAuthorUID").value as! String
                    let ideaCommentText = comment.childSnapshot(forPath: "ideaCommentText").value as! String
                    let timestamp = comment.childSnapshot(forPath: "timestamp").value as! Double
                    
                    let newComment = IdeaCommentData(ideaCommentAuthorName: ideaCommentAuthorName, ideaCommentAuthorUID: ideaCommentAuthorUID, ideaCommentText: ideaCommentText, timestamp: timestamp)
                    commentData.append(newComment)
                }
                commentData.sort{
                    $0.timestamp > $1.timestamp
                }
                
                var interestedUsersData = [UserData]()
                let interestedUsers = ideaSnapshot.childSnapshot(forPath: "interestedUsers")
                for child in interestedUsers.children{
                    let user = child as! DataSnapshot
                    let userUID = user.childSnapshot(forPath: "uid").value as! String
                    let name = user.childSnapshot(forPath: "name").value as! String
                    let majors = user.childSnapshot(forPath: "majors").value as! [String]
                    
                    let newUser = UserData(userUID: userUID, name: name, major: majors)
                    interestedUsersData.append(newUser)
                }
                interestedUsersData.sort{
                    $0.name > $1.name
                }
                
                
                let idea = IdeaData(ideaReference: ideaReference, ideaTitle: ideaTitle, ideaSubtitle: ideaSubtitle, ideaDescription: ideaDescription, roles: roles, ideaAuthorUID: ideaAuthorUID, ideaAuthorName: ideaAuthorName, ideaAuthorMajor: ideaAuthorMajor, comments: commentData, interestedUsers: interestedUsersData, timestamp: timestamp)

            completed(idea)
        })
    }

    //CalledFrom ProfileVC, NewIdeaVC, CommentVC
    func observeUser(uid: String, completed: @escaping (UserData) -> ()){
        var user: UserData!
        firebaseUsersRef.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let userUID = snapshot.childSnapshot(forPath: "uid").value as! String
            let userName = snapshot.childSnapshot(forPath: "name").value as! String
            let userEmail = snapshot.childSnapshot(forPath: "email").value as! String
            let userBio = snapshot.childSnapshot(forPath: "bio").value as! String

            let userMajors = snapshot.childSnapshot(forPath: "majors").value as! [String]
            
            
            var ideas = [IdeaData]()
            let userIdeas = snapshot.childSnapshot(forPath: "Ideas")
            for child in userIdeas.children{
                let idea = child as! DataSnapshot
                let ideaReference = idea.key
                let ideaTitle = idea.childSnapshot(forPath: "ideaTitle").value as! String
                let ideaSubTitle = idea.childSnapshot(forPath: "ideaSubtitle").value as! String
                let ideaDescription = idea.childSnapshot(forPath: "ideaDescription").value as! String
                let roles = idea.childSnapshot(forPath: "rolesRequired").value as! [String]
                let ideaAuthorUID = idea.childSnapshot(forPath: "ideaAuthorUID").value as! String
                let timestamp = idea.childSnapshot(forPath: "timestamp").value as! Double
            
                let newIdea = IdeaData(ideaReference: ideaReference, ideaTitle: ideaTitle, ideaSubtitle: ideaSubTitle, ideaDescription: ideaDescription, roles: roles, ideaAuthorUID: ideaAuthorUID, timestamp: timestamp)
                ideas.append(newIdea)
            }
            
            user = UserData(userUID: userUID, name: userName, email: userEmail, major: userMajors, bio: userBio, ideas: ideas)
            completed(user)
        })
    }

    
    //Called from AllUsersVC
    func observeUsers(completed: @escaping ([UserData]) -> ()){
        var users = [UserData]()
        firebaseUsersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                
                let user = child as! DataSnapshot
                print(user.childSnapshot(forPath: "majors"))
                let uid = user.childSnapshot(forPath: "uid").value as! String
                let name = user.childSnapshot(forPath: "name").value as! String
                let majors = user.childSnapshot(forPath: "majors").value as! [String]

                let newUser = UserData(userUID: uid, name: name, major: majors)
                users.append(newUser)
            }
            users.sort{
                $0.name < $1.name
            }
            completed(users)
        })
    
    
    }
    
    //MARK: ---------------------
    //MARK: REMOVING VALUES FROM FIREBASE
    //MARK: ---------------------
    
    //Allows users to delete their own ideas
    //Called from IdeaFeedVC, ProfileVC
    func deleteIdea(userUID: String, ideaReference: String){
        firebaseUsersRef.child(userUID).child("Ideas").child(ideaReference).removeValue()
        firebaseIdeasRef.child(ideaReference).removeValue()
    }
    
    
}
